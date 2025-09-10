//
//  MediaCache.swift
//  LazyLoadGallery
//
//  Created by Mustafa Bekirov on 10.09.2025.
//

import UIKit

protocol ImageCaching {
    func image(forKey key: String) -> UIImage?
    func setImage(_ image: UIImage, forKey key: String)
}

final class ImageCache: ImageCaching {
    static let shared = ImageCache()
    private let cache = NSCache<NSString, UIImage>()
    func image(forKey key: String) -> UIImage? { cache.object(forKey: key as NSString) }
    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}
