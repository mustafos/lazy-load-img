//
//  PostCell.swift
//  LazyLoadGallery
//
//  Created by Mustafa Bekirov on 10.09.2025.
//

import SwiftUI

struct PostCell: View {
    @ObservedObject var vm: PostCellViewModel
    let visibleRatio: CGFloat
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(vm.post.author).font(.headline)
            content
            if let caption = vm.post.caption { Text(caption).font(.subheadline) }
        }
        .padding(.bottom, 16)
    }
    
    @ViewBuilder
    private var content: some View {
        switch vm.post.kind {
        case .photo(let media):
            PhotoView(name: nameFor(media), targetSize: CGSize(width: UIScreen.main.bounds.width, height: 400))
                .frame(height: 400)
                .cornerRadius(12)
        case .video(let media):
            VideoPlayerView(videoName: nameFor(media), shouldPlay: visibleRatio >= 0.5)
                .cornerRadius(12)
        case .mixed(let photo, let video):
            PhotoView(name: nameFor(photo), targetSize: CGSize(width: UIScreen.main.bounds.width, height: 240))
                .frame(height: 240)
                .cornerRadius(12)
            VideoPlayerView(videoName: nameFor(video), shouldPlay: visibleRatio >= 0.5)
                .cornerRadius(12)
        }
    }
    
    private func nameFor(_ media: Media) -> String {
        switch media.kind {
        case .photo(let name), .video(let name): return name
        }
    }
}
