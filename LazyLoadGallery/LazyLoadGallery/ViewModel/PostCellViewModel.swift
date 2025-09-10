//
//  PostCellViewModel.swift
//  LazyLoadGallery
//
//  Created by Mustafa Bekirov on 28.05.2024.
//

import SwiftUI

final class PostCellViewModel: ObservableObject, Identifiable {
    let id: UUID
    let post: Post
    
    @Published var isLiked: Bool = false
    @Published var likeCount: Int
    @Published var isMuted: Bool = true
    @Published var showMenu: Bool = false
    
    init(post: Post) {
        self.post = post
        self.id = post.id
        self.likeCount = Int.random(in: 350...9200)
    }
    
    func toggleLike(haptic: Bool = true) {
        if isLiked {
            isLiked = false
            likeCount = max(0, likeCount - 1)
        } else {
            isLiked = true
            likeCount += 1
            if haptic {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            }
        }
    }
    
    func toggleMenu() { showMenu.toggle() }
}
