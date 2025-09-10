//
//  VideoPlayerCard.swift
//  LazyLoadGallery
//
//  Created by Mustafa Bekirov on 10.09.2025.
//

import SwiftUI
import AVKit

struct VideoPlayerCard: View {
    let name: String
    let shouldPlay: Bool
    @Binding var isMuted: Bool
    
    @State private var player: AVPlayer?
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            if let player = player {
                VideoPlayer(player: player)
                    .disabled(true)
                    .onAppear {
                        player.isMuted = isMuted
                        player.volume = isMuted ? 0 : 1
                        if shouldPlay { player.play() }
                    }
                    .onDisappear {
                        player.pause()
                        PlayerPool.shared.release(key: name)
                    }
                    .onChange(of: shouldPlay) { play in
                        play ? player.play() : player.pause()
                    }
                    .onChange(of: isMuted) { muted in
                        player.isMuted = muted
                        player.volume = muted ? 0 : 1
                    }
            } else {
                Color.black
                    .onAppear {
                        if let p = PlayerPool.shared.acquire(key: name) {
                            p.isMuted = isMuted
                            p.volume  = isMuted ? 0 : 1
                            player = p
                            if shouldPlay { p.play() }
                        }
                    }
            }
            
            MuteButton(isMuted: $isMuted)
                .padding(10)
        }
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.corner, style: .continuous))
        .shadow(color: AppTheme.shadow.color.opacity(0.5), radius: 8, x: 0, y: 4)
    }
}
