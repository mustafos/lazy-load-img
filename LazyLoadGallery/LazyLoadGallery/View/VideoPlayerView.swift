//
//  VideoPlayerView.swift
//  LazyLoadGallery
//
//  Created by Mustafa Bekirov on 10.09.2025.
//

import SwiftUI
import AVKit

struct VideoPlayerView: View {
    let videoName: String
    let shouldPlay: Bool
    
    @State private var player: AVPlayer?
    @State private var isMuted = true
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VideoPlayer(player: player)
                .disabled(true)             
                .overlay(Color.clear)
                .onAppear {
                    if player == nil {
                        player = PlayerPool.shared.acquire(key: videoName)
                        player?.isMuted = isMuted
                    }
                    if shouldPlay { player?.play() }
                }
                .onChange(of: shouldPlay) { play in
                    play ? player?.play() : player?.pause()
                }
                .onDisappear {
                    player?.pause()
                    PlayerPool.shared.release(key: videoName)
                }
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            
            // Mute/unmute button
            Button {
                isMuted.toggle()
                player?.isMuted = isMuted
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            } label: {
                Image(systemName: isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                    .font(.caption)
                    .padding(8)
                    .background(.ultraThinMaterial, in: Circle())
            }
            .padding(10)
        }
        .aspectRatio(9/16, contentMode: .fit)
    }
}
