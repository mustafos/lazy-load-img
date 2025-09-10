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
    @State private var heartScale: CGFloat = 0.2
    @State private var isMuted = true
    @State private var showMenu = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack(spacing: 12) {
                AvatarView(initials: vm.post.author.prefix(1).uppercased(), size: 40)
                VStack(alignment: .leading, spacing: 2) {
                    Text(vm.post.author).font(.headline.weight(.semibold))
                    Text("@\(vm.post.author.lowercased()) • 1h")
                        .font(.footnote).foregroundColor(AppTheme.textSecondary)
                }
                Spacer()
                Button {
                    showMenu.toggle()
                } label: {
                    Image(systemName: "ellipsis").rotationEffect(.degrees(90))
                        .foregroundColor(AppTheme.textSecondary).padding(8)
                }
                .confirmationDialog("Actions", isPresented: $showMenu) {
                    Button("Report", role: .destructive) {}
                    Button("Share") {}
                }
            }
            
            // Media + double-tap like + heart
            ZStack {
                content
                
                if showHeart {
                    Image(systemName: "heart.fill")
                        .resizable()
                        .foregroundColor(.red)
                        .frame(width: 120, height: 120)
                        .scaleEffect(heartScale)
                        .opacity(0.98)
                        .shadow(color: .red.opacity(0.35), radius: 12, x: 0, y: 6)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture(count: 2) { performLikeWithBeat() }
            
            // Action bar
            HStack(spacing: 16) {
                MetricButton(system: isLiked ? "heart.fill" : "heart",
                             title: "\(likeCount)",
                             activeColor: isLiked ? AppTheme.like : nil) { performLikeWithBeat() }
                MetricButton(system: "bubble.right", title: "121") {}
                MetricButton(system: "arrowshape.turn.up.forward", title: "Share") {}
                Spacer()
                Button { } label: { Image(systemName: "bookmark").foregroundColor(AppTheme.textSecondary) }
            }
            
            if let caption = vm.post.caption {
                Text(caption)
                    .font(.body)
                    .foregroundColor(AppTheme.textPrimary)
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.corner, style: .continuous)
                .fill(AppTheme.card)
                .shadow(color: AppTheme.shadow.color, radius: AppTheme.shadow.radius, x: 0, y: AppTheme.shadow.y)
        )
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }
    
    // MARK: Content
    @ViewBuilder
    private var content: some View {
        switch vm.post.kind {
        case .photo(let m):
            PhotoView(
                name: nameFor(m),
                targetSize: CGSize(width: UIScreen.main.bounds.width - 32,
                                   height: (UIScreen.main.bounds.width - 32) * 0.75)
            )
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.corner, style: .continuous))
            
        case .video(let v):
            VideoPlayerCard(name: nameFor(v),
                            shouldPlay: visibleRatio >= 0.25,
                            isMuted: $isMuted)
            
        case .mixed(let photo, let video):
            MediaPagerView(
                photoName: nameFor(photo),
                videoName: nameFor(video),
                visibleRatio: visibleRatio,
                isMuted: $isMuted
            )
        }
    }
    
    private func nameFor(_ media: Media) -> String {
        switch media.kind { case .photo(let n), .video(let n): return n }
    }
    
    // MARK: Like + heartbeat animation
    private func performLikeWithBeat() {
        if !isLiked {
            isLiked = true
            likeCount += 1
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            
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
        } else {
            isLiked = false
            likeCount = max(0, likeCount - 1)
        }
    }
}
