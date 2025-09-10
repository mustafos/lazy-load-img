//
//  Media.swift
//  LazyLoadGallery
//
//  Created by Mustafa Bekirov on 10.09.2025.
//

import Foundation

enum MediaKind { case photo(name: String), video(name: String) }

struct Media: Identifiable {
    let id = UUID()
    let kind: MediaKind
}
