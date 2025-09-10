//
//  FeedViewModel.swift
//  LazyLoadGallery
//
//  Created by Mustafa Bekirov on 10.09.2025.
//

import Foundation

final class FeedViewModel: ObservableObject {
    @Published var posts: [PostCellViewModel] = []

    init() { loadMock() }

    func loadMock() {
        let p1 = Media(kind: .photo(name: "photo1.jpg"))
        let p2 = Media(kind: .photo(name: "photo2.jpg"))
        let v1 = Media(kind: .video(name: "video1.mp4"))
        let v2 = Media(kind: .video(name: "video2.mp4"))

        let feed: [Post] = [
            .init(kind: .photo(p1), author: "alice", caption: "Sunset"),
            .init(kind: .video(v1), author: "bob", caption: "Ride"),
            .init(kind: .mixed(photo: p2, video: v2), author: "carol", caption: "Behind the scenes"),
            .init(kind: .photo(p2), author: "dave", caption: nil),
            .init(kind: .video(v2), author: "erin", caption: "Looping demo")
        ]
        posts = feed.map(PostCellViewModel.init)
    }
}
