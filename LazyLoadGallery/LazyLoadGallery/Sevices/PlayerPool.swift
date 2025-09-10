//
//  PlayerPool.swift
//  LazyLoadGallery
//
//  Created by Mustafa Bekirov on 10.09.2025.
//

import Foundation
import AVFoundation
import UIKit

/// Reusable AVPlayer pool with reference counting and simple LRU eviction.
final class PlayerPool {
    
    static let shared = PlayerPool()
    
    private struct Entry {
        let player: AVPlayer
        var refCount: Int
        var lastUsed: TimeInterval
    }
    
    private let queue = DispatchQueue(label: "player.pool.queue")
    private var store: [String: Entry] = [:]
    private let maxCapacity = 4 // tweak for your feed size
    
    private init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleMemoryWarning),
            name: UIApplication.didReceiveMemoryWarningNotification,
            object: nil
        )
    }
    
    /// Acquire (rent) a player for a key (e.g. bundled file name "video1.mp4")
    func acquire(key: String) -> AVPlayer? {
        queue.sync {
            let now = CACurrentMediaTime()
            if var entry = store[key] {
                entry.refCount += 1
                entry.lastUsed = now
                store[key] = entry
                return entry.player
            } else {
                guard let url = urlFor(key: key) else { return nil }
                let item = AVPlayerItem(url: url)
                let player = AVPlayer(playerItem: item)
                player.isMuted = true
                // loop
                NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: item, queue: .main) { [weak player] _ in
                    player?.seek(to: .zero)
                    player?.play()
                }
                store[key] = Entry(player: player, refCount: 1, lastUsed: now)
                evictIfNeeded()
                return player
            }
        }
    }
    
    /// Release (return) a player for a key
    func release(key: String) {
        queue.sync {
            guard var entry = store[key] else { return }
            entry.refCount = max(0, entry.refCount - 1)
            entry.lastUsed = CACurrentMediaTime()
            if entry.refCount == 0 {
                entry.player.pause()
                entry.player.seek(to: .zero)
            }
            store[key] = entry
        }
    }
    
    /// Prepare players ahead of time (no refCount increase).
    func preheat(keys: [String]) {
        queue.sync {
            let now = CACurrentMediaTime()
            for key in keys {
                if store[key] != nil { continue }
                guard let url = urlFor(key: key) else { continue }
                let item = AVPlayerItem(url: url)
                let player = AVPlayer(playerItem: item)
                player.isMuted = true
                NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: item, queue: .main) { [weak player] _ in
                    player?.seek(to: .zero)
                    player?.play()
                }
                store[key] = Entry(player: player, refCount: 0, lastUsed: now)
            }
            evictIfNeeded()
        }
    }
    
    /// For demo we resolve bundled file by key
    private func urlFor(key: String) -> URL? {
        let name = (key as NSString).deletingPathExtension
        let ext = (key as NSString).pathExtension
        return Bundle.main.url(forResource: name, withExtension: ext.isEmpty ? nil : ext)
    }
    
    private func evictIfNeeded() {
        // Keep only maxCapacity entries with preference to those with refCount > 0.
        if store.count <= maxCapacity { return }
        let candidates = store
            .filter { $0.value.refCount == 0 }
            .sorted { $0.value.lastUsed < $1.value.lastUsed } // oldest first
        var toRemove = store.count - maxCapacity
        for (key, _) in candidates {
            store.removeValue(forKey: key)
            toRemove -= 1
            if toRemove == 0 { break }
        }
    }
    
    @objc private func handleMemoryWarning() {
        queue.sync {
            // Remove all zero-ref players on memory warning
            store = store.filter { $0.value.refCount > 0 }
        }
    }
}
