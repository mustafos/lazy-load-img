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
    @State private var headerProgress: CGFloat = 0
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 0) {
                HeaderView(appName: "Feed")
                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(vm.posts) { cellVM in
                            PostCell(vm: cellVM, visibleRatio: vis[cellVM.id] ?? 0)
                                .reportVisibility(id: cellVM.id)
                        }
                    }
                    .padding(.top, 8)
                }
                .scrollIndicators(.hidden)
                .onPreferenceChange(VisibilityKey.self) { vis = $0 }
                .onAppear { preheatImages(); preheatVideos() }
                .refreshable {
                    withAnimation {
                        preheatImages(); preheatVideos()
                    }
                }
            }
            .background(AppTheme.bg.ignoresSafeArea())
            
            // FAB
            GradientFAB()
        }
        .background(AppTheme.bg.ignoresSafeArea())
        .onAppear { preheatImages(); preheatVideos() }
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
