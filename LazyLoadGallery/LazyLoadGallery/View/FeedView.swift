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
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(vm.posts) { cellVM in
                    PostCell(vm: cellVM, visibleRatio: vis[cellVM.id] ?? 0)
                        .reportVisibility(id: cellVM.id)
                        .padding(.horizontal)
                }
            }
        }
        .onPreferenceChange(VisibilityKey.self) { vis = $0 }
        .onAppear { preheatImages() }
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
    
    private func nameFor(_ media: Media) -> String {
        switch media.kind {
        case .photo(let n), .video(let n): return n
        }
    }
}
