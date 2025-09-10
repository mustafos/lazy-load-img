//
//  FeedViewModel.swift
//  LazyLoadGallery
//
//  Created by Mustafa Bekirov on 10.09.2025.
//

import SwiftUI

final class FeedViewModel: ObservableObject {
    @Published var posts: [PostCellViewModel] = []
    
    init() { loadMock() }
    
    func loadMock() {
        let p1 = Media(kind: .photo(name: "photo1.jpg"))
        let p2 = Media(kind: .photo(name: "photo2.jpg"))
        let v1 = Media(kind: .video(name: "video1.mp4"))
        let v2 = Media(kind: .video(name: "video2.mp4"))
        
        let feed: [Post] = [
            .init(kind: .photo(p1), author: "alice", caption: "Golden sunset over the horizon"),
            .init(kind: .video(v1), author: "bob", caption: "Evening ride through the city"),
            .init(kind: .mixed(photo: p2, video: v2), author: "carol", caption: "Behind-the-scenes moments"),
            .init(kind: .photo(p2), author: "dave", caption: "Captured in silence"),
            .init(kind: .video(v2), author: "erin", caption: "Endless looping demo")
        ]
        posts = feed.map(PostCellViewModel.init)
    }
    
    // MARK: - Preheat / Cache
    
    func preheatImages(screenWidth: CGFloat) {
        DispatchQueue.global(qos: .userInitiated).async {
            let loader = ImageLoader()
            let size = CGSize(width: screenWidth, height: 400)
            for vm in self.posts.prefix(4) {
                switch vm.post.kind {
                case .photo(let m):
                    _ = loader.loadBundledImage(named: m.filename, targetSize: size)
                case .mixed(let photo, _):
                    _ = loader.loadBundledImage(named: photo.filename, targetSize: size)
                default: break
                }
            }
        }
    }
    
    func preheatVideos() {
        DispatchQueue.global(qos: .utility).async {
            let keys = self.posts.compactMap { cell -> String? in
                switch cell.post.kind {
                case .video(let m): return m.filename
                case .mixed(_, let v): return v.filename
                default: return nil
                }
            }.prefix(3)
            PlayerPool.shared.preheat(keys: Array(keys))
        }
    }
}

// MARK: - Helpers
extension Media {
    var filename: String {
        switch kind {
        case .photo(let n), .video(let n): return n
        }
    }
}
