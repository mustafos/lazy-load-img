//
//  FeedView.swift
//  LazyLoadGallery
//
//  Created by Mustafa Bekirov on 28.05.2024.
//

import SwiftUI

struct FeedView: View {
    @StateObject var vm = FeedViewModel()
    @State private var vis: [UUID: CGFloat] = [:]
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(vm.posts) { cellVM in
                        PostCell(vm: cellVM, visibleRatio: vis[cellVM.id] ?? 0)
                            .reportVisibility(id: cellVM.id)
                    }
                    .padding(.top, 8)
                }
            }
            .background(AppTheme.bg.ignoresSafeArea())
            .onPreferenceChange(VisibilityKey.self) { vis = $0 }
            .onAppear { preheatImages(); preheatVideos() }
            
            Button {
                // create post
            } label: {
                Image(systemName: "plus")
                    .font(.title2.bold())
                    .foregroundColor(.white)
                    .padding(18)
                    .background(AppTheme.accent, in: Circle())
                    .shadow(color: AppTheme.accent.opacity(0.35), radius: 16, x: 0, y: 8)
            }
            .padding(.trailing, 22)
            .padding(.bottom, 22)
        }
    }
    
    
    private func preheatImages() {
        let loader = ImageLoader()
        let width = UIScreen.main.bounds.width
        let size = CGSize(width: width, height: 400)
        vm.posts.prefix(4).forEach { cellVM in
            switch cellVM.post.kind {
            case .photo(let m):
                _ = loader.loadBundledImage(named: nameFor(m), targetSize: size)
            case .mixed(let photo, _):
                _ = loader.loadBundledImage(named: nameFor(photo), targetSize: size)
            default: break
            }
        }
    }
    
    private func preheatVideos() {
        let videoKeys: [String] = vm.posts.compactMap {
            switch $0.post.kind {
            case .video(let m): return nameFor(m)
            case .mixed(_, let v): return nameFor(v)
            default: return nil
            }
        }
            .prefix(3)
            .map { $0 }
        PlayerPool.shared.preheat(keys: Array(videoKeys))
    }
    
    private func nameFor(_ media: Media) -> String {
        switch media.kind {
        case .photo(let n), .video(let n): return n
        }
    }
}
