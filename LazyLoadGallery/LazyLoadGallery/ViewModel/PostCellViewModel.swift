//
//  PostCellViewModel.swift
//  LazyLoadGallery
//
//  Created by Mustafa Bekirov on 28.05.2024.
//

import Foundation

final class PostCellViewModel: ObservableObject, Identifiable {
    let id: UUID
    let post: Post
    init(post: Post) { self.post = post; self.id = post.id }
}
