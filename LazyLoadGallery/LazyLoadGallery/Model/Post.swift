//
//  Post.swift
//  LazyLoadGallery
//
//  Created by Mustafa Bekirov on 28.05.2024.
//

import Foundation

enum PostKind { case photo(Media), video(Media), mixed(photo: Media, video: Media) }

struct Post: Identifiable {
    let id = UUID()
    let kind: PostKind
    let author: String
    let caption: String?
}
