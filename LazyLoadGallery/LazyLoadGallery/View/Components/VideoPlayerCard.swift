//
//  VideoPlayerCard.swift
//  LazyLoadGallery
//
//  Created by Mustafa Bekirov on 10.09.2025.
//

import SwiftUI
import AVKit

extension Notification.Name {
    static let toggleMute = Notification.Name("toggleMutePerPost")
}

struct VideoPlayerCard: View {
    let name: String
    let shouldPlay: Bool
    @Binding var isMuted: Bool
    
    @State private var player: AVPlayer?
    
    var body: some View {
        VideoPlayer(player: player)
            .onAppear {
                if player == nil {
                    player = PlayerPool.shared.acquire(key: name)
                    player?.isMuted = isMuted
                }
                if shouldPlay { player?.play() }
            }
            .onChange(of: shouldPlay) { $0 ? player?.play() : player?.pause() }
            .onChange(of: isMuted) { player?.isMuted = $0 }
            .onReceive(NotificationCenter.default.publisher(for: .toggleMute)) { note in
                if let (postID, state) = note.object as? (UUID, Bool) {
                    player?.isMuted = state
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.corner, style: .continuous))
            .shadow(color: AppTheme.shadow.color.opacity(0.5),
                    radius: 8, x: 0, y: 4)
            .aspectRatio(9/16, contentMode: .fit)
    }
}
