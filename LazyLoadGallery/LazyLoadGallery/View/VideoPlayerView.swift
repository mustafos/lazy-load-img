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

    var body: some View {
        VideoPlayer(player: player)
            .onAppear {
                if player == nil {
                    player = PlayerPool.shared.acquire(key: videoName)
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
            .aspectRatio(9/16, contentMode: .fit)
            .cornerRadius(12)
    }
}
