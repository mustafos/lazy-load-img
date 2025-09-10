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
    @State private var likeCount = Int.random(in: 350...9200)
    @State private var showHeart = false
    @State private var isMuted = true
    @State private var showMenu = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            // Header
            HStack(alignment: .center, spacing: 12) {
                AvatarView(initials: vm.post.author.prefix(1).uppercased(), size: 40)
                VStack(alignment: .leading, spacing: 2) {
                    Text(vm.post.author)
                        .font(.headline.weight(.semibold))
                    Text("@\(vm.post.author.lowercased()) • 1h")
                        .font(.footnote)
                        .foregroundColor(AppTheme.textSecondary)
                }
                Spacer()
                Button {
                    showMenu = true
                } label: {
                    Image(systemName: "ellipsis")
                        .rotationEffect(.degrees(90))
                        .foregroundColor(AppTheme.textSecondary)
                        .padding(8)
                }
                .confirmationDialog("Actions", isPresented: $showMenu) {
                    Button("Report", role: .destructive) {}
                    Button("Share") {}
                }
            }

            // Media
            ZStack(alignment: .topTrailing) {
                mediaContent()

                // mute/unmute for video
                if isVideo {
                    Button {
                        isMuted.toggle()
                        NotificationCenter.default.post(name: .toggleMute, object: (vm.id, isMuted))
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    } label: {
                        Image(systemName: isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                            .font(.caption)
                            .padding(8)
                            .background(.ultraThinMaterial, in: Circle())
                    }
                    .padding(10)
                }

                if showHeart {
                    Image(systemName: "heart.fill")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 110, height: 110)
                        .scaleEffect(showHeart ? 1.0 : 0.5)
                        .opacity(showHeart ? 1.0 : 0.0)
                        .shadow(radius: 10)
                        .animation(.easeOut(duration: 0.25), value: showHeart)
                }
            }
            .onTapGesture(count: 2) { performLike() }

            // Action bar
            HStack(spacing: 16) {
                MetricButton(system: isLiked ? "heart.fill" : "heart",
                             title: "\(likeCount)",
                             activeColor: isLiked ? AppTheme.like : nil) { performLike() }
                MetricButton(system: "bubble.right", title: "121") {}
                MetricButton(system: "arrowshape.turn.up.forward", title: "Share") {}
                Spacer()
                Button {
                    // save/bookmark
                } label: {
                    Image(systemName: "bookmark")
                        .foregroundColor(AppTheme.textSecondary)
                }
            }

            // Caption
            if let caption = vm.post.caption {
                Text(caption + " 🙂✨")
                    .font(.body)
                    .foregroundColor(AppTheme.textPrimary)
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.corner, style: .continuous)
                .fill(AppTheme.card)
                .shadow(color: AppTheme.shadow.color,
                        radius: AppTheme.shadow.radius,
                        x: 0, y: AppTheme.shadow.y)
        )
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }

    // MARK: - Helpers

    private var isVideo: Bool {
        if case .video = vm.post.kind { return true }
        if case .mixed(_, _) = vm.post.kind { return true }
        return false
    }

    @ViewBuilder
    private func mediaContent() -> some View {
        switch vm.post.kind {
        case .photo(let m):
            PhotoView(name: nameFor(m),
                      targetSize: CGSize(width: UIScreen.main.bounds.width - 32,
                                         height: UIScreen.main.bounds.width * 0.75))
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.corner, style: .continuous))

        case .video(let v):
            VideoPlayerCard(name: nameFor(v),
                            shouldPlay: visibleRatio >= 0.25,
                            isMuted: $isMuted)

        case .mixed(let photo, let video):
            VStack(spacing: 12) {
                PhotoView(name: nameFor(photo),
                          targetSize: CGSize(width: UIScreen.main.bounds.width - 32,
                                             height: UIScreen.main.bounds.width * 0.6))
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.corner, style: .continuous))
                VideoPlayerCard(name: nameFor(video),
                                shouldPlay: visibleRatio >= 0.25,
                                isMuted: $isMuted)
            }
        }
    }

    private func nameFor(_ media: Media) -> String {
        switch media.kind { case .photo(let n), .video(let n): return n }
    }

    private func performLike() {
        if !isLiked {
            isLiked = true
            likeCount += 1
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            withAnimation { showHeart = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                withAnimation(.easeOut(duration: 0.25)) { showHeart = false }
            }
        } else {
            isLiked = false
            likeCount = max(0, likeCount - 1)
        }
    }
}
