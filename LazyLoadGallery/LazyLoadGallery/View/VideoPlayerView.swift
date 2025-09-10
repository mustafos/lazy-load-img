//
//  VideoPlayerView.swift
//  LazyLoadGallery
//
//  Created by Mustafa Bekirov on 10.09.2025.
//

import SwiftUI
import AVFoundation
import AVKit

struct VideoPlayerView: View {
    @StateObject private var ctrl: Controller
    let shouldPlay: Bool
    
    init(videoName: String, shouldPlay: Bool) {
        _ctrl = StateObject(wrappedValue: Controller(videoName: videoName))
        self.shouldPlay = shouldPlay
    }
    
    var body: some View {
        VideoPlayer(player: ctrl.player)
            .onAppear { ctrl.prepare() }
            .onChange(of: shouldPlay) { play in
                play ? ctrl.play() : ctrl.pause()
            }
            .onDisappear { ctrl.pause() }
            .aspectRatio(9/16, contentMode: .fit)
    }
    
    final class Controller: ObservableObject {
        let player = AVPlayer()
        private let name: String
        init(videoName: String) { self.name = videoName }
        func prepare() {
            guard player.currentItem == nil,
                  let url = Bundle.main.url(forResource: name, withExtension: nil) else { return }
            let item = AVPlayerItem(url: url)
            player.replaceCurrentItem(with: item)
            player.isMuted = true
            NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: item, queue: .main) { [weak self] _ in
                self?.player.seek(to: .zero); self?.player.play()
            }
        }
        func play() { player.play() }
        func pause() { player.pause() }
    }
}
