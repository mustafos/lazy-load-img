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
    
    @State private var isLiked = false
    @State private var likeCount = Int.random(in: 25...120)
    @State private var showHeart = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Header
            HStack(spacing: 12) {
                Circle()
                    .fill(Color.blue.opacity(0.15))
                    .frame(width: 36, height: 36)
                    .overlay(Text(vm.post.author.prefix(1).uppercased()).font(.headline))
                Text(vm.post.author).font(.headline)
                Spacer()
            }
            
            // Content with double-tap gesture
            ZStack {
                content
                    .onTapGesture(count: 2) { performLike() } // double tap
                
                if showHeart {
                    Image(systemName: "heart.fill")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 100, height: 100)
                        .scaleEffect(showHeart ? 1.0 : 0.5)
                        .opacity(showHeart ? 1.0 : 0.0)
                        .animation(.easeOut(duration: 0.3), value: showHeart)
                        .shadow(radius: 8)
                }
            }
            
            // Actions
            HStack(spacing: 14) {
                Button(action: performLike) {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .font(.title3)
                        .foregroundColor(isLiked ? .red : .primary)
                        .scaleEffect(isLiked ? 1.2 : 1.0)
                        .animation(.spring(response: 0.25, dampingFraction: 0.55), value: isLiked)
                }
                Text("\(likeCount)")
                    .font(.subheadline)
                    .foregroundColor(.primary)
                Spacer()
            }
            
            // Caption
            if let caption = vm.post.caption {
                Text(caption)
                    .font(.body)
                    .foregroundColor(.primary)
                    .padding(.top, 2)
            }
        }
        .padding(.bottom, 16)
    }
    
    @ViewBuilder
    private var content: some View {
        Group {
            switch vm.post.kind {
            case .photo(let media):
                mediaContent(nameFor(media))

            case .video(let media):
                mediaContent(nameFor(media), isVideo: true)

            case .mixed(let photo, let video):
                VStack(spacing: 10) {
                    mediaContent(nameFor(photo))
                    mediaContent(nameFor(video), isVideo: true)
                }
            }
        }
    }

    private func mediaContent(_ name: String, isVideo: Bool = false) -> some View {
        ZStack {
            if isVideo {
                VideoPlayerView(videoName: name, shouldPlay: visibleRatio >= 0.25)
            } else {
                PhotoView(
                    name: name,
                    targetSize: CGSize(width: UIScreen.main.bounds.width,
                                       height: UIScreen.main.bounds.width * (isVideo ? 16/9 : 3/4))
                )
            }

            if showHeart {
                Image(systemName: "heart.fill")
                    .resizable()
                    .foregroundColor(.white)
                    .frame(width: 100, height: 100)
                    .scaleEffect(showHeart ? 1.0 : 0.5)
                    .opacity(showHeart ? 1.0 : 0.0)
                    .animation(.easeOut(duration: 0.3), value: showHeart)
                    .shadow(radius: 8)
            }
        }
        .onTapGesture(count: 2) { performLike() }
    }
    
    private func nameFor(_ media: Media) -> String {
        switch media.kind {
        case .photo(let name), .video(let name): return name
        }
    }
    
    private func performLike() {
        if !isLiked {
            isLiked = true
            likeCount += 1
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            withAnimation {
                showHeart = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                withAnimation {
                    showHeart = false
                }
            }
        } else {
            isLiked.toggle()
            likeCount -= 1
        }
    }
}
