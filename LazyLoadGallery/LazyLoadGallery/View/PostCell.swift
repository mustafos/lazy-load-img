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

    @State private var showHeart = false
    @State private var heartScale: CGFloat = 0.2

    private var mediaW: CGFloat { UIScreen.main.bounds.width - 32 }
    private var mediaH: CGFloat { mediaW * (16.0 / 9.0) }
    private var mediaSize: CGSize { .init(width: mediaW, height: mediaH) }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            // Header
            HStack(spacing: 12) {
                AvatarView(initials: vm.post.author.prefix(1).uppercased(), size: 40)
                VStack(alignment: .leading, spacing: 2) {
                    Text(vm.post.author).font(.headline.weight(.semibold))
                    Text("@\(vm.post.author.lowercased()) • 1h")
                        .font(.footnote)
                        .foregroundColor(AppTheme.textSecondary)
                }
                Spacer()
                Button { vm.toggleMenu() } label: {
                    Image(systemName: "ellipsis")
                        .rotationEffect(.degrees(90))
                        .foregroundColor(AppTheme.textSecondary)
                }
                .confirmationDialog("Actions", isPresented: $vm.showMenu) {
                    Button("Report", role: .destructive) {}
                    Button("Share") {}
                }
            }

            // Media + double-tap like
            ZStack {
                content
                if showHeart {
                    Image(systemName: "heart.fill")
                        .resizable()
                        .foregroundStyle(.red)
                        .frame(width: 120, height: 120)
                        .scaleEffect(heartScale)
                        .opacity(0.95)
                        .shadow(color: .red.opacity(0.35), radius: 12, x: 0, y: 6)
                }
            }
            .frame(width: mediaW, height: mediaH)
            .contentShape(Rectangle())
            .onTapGesture(count: 2) { likeWithBeat() }

            // Action bar
            HStack(spacing: 20) {
                MetricButton(system: vm.isLiked ? "heart.fill" : "heart",
                             title: "\(vm.likeCount)",
                             activeColor: vm.isLiked ? AppTheme.like : nil) {
                    likeWithBeat()
                }
                MetricButton(system: "bubble.right", title: "121") {}
                MetricButton(system: "arrowshape.turn.up.forward", title: "Share") {}
                Spacer()
                Button { } label: {
                    Image(systemName: "bookmark")
                        .foregroundColor(AppTheme.textSecondary)
                }
            }

            if let caption = vm.post.caption {
                Text(caption)
                    .font(.body)
                    .foregroundColor(AppTheme.textPrimary)
                    .padding([.leading, .bottom], 8)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.corner, style: .continuous)
                .fill(AppTheme.card)
                .shadow(color: AppTheme.shadow.color,
                        radius: AppTheme.shadow.radius,
                        x: 0, y: AppTheme.shadow.y)
        )
        .padding(.top, 8)
    }

    // MARK: - Media
    @ViewBuilder
    private var content: some View {
        switch vm.post.kind {
        case .photo(let m):
            PhotoView(name: m.filename, targetSize: mediaSize)
                .frame(width: mediaW, height: mediaH)
                .clipped()

        case .video(let v):
            VideoPlayerCard(name: v.filename,
                            shouldPlay: visibleRatio >= 0.25,
                            isMuted: $vm.isMuted)
                .frame(width: mediaW, height: mediaH)
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.corner, style: .continuous))

        case .mixed(let photo, let video):
            MediaPagerView(photoName: photo.filename,
                           videoName: video.filename,
                           visibleRatio: visibleRatio,
                           targetSize: mediaSize,
                           isMuted: $vm.isMuted)
                .frame(width: mediaW, height: mediaH)
        }
    }

    // MARK: - Like animation (UI)
    private func likeWithBeat() {
        let wasLiked = vm.isLiked
        vm.toggleLike()

        guard !wasLiked else { return }
        showHeart = true
        heartScale = 0.2

        withAnimation(.spring(response: 0.22, dampingFraction: 0.55)) { heartScale = 1.25 }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.22) {
            withAnimation(.spring(response: 0.18, dampingFraction: 0.80)) { heartScale = 0.92 }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.40) {
            withAnimation(.spring(response: 0.20, dampingFraction: 0.60)) { heartScale = 1.10 }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.62) {
            withAnimation(.easeOut(duration: 0.20)) { heartScale = 1.0 }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
            withAnimation(.easeOut(duration: 0.18)) { showHeart = false }
        }
    }
}
