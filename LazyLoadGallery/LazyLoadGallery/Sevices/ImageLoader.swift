//
//  ImageLoader.swift
//  LazyLoadGallery
//
//  Created by Mustafa Bekirov on 10.09.2025.
//

import UIKit

final class ImageLoader {
    private let cache: ImageCaching
    init(cache: ImageCaching = ImageCache.shared) { self.cache = cache }

    func loadBundledImage(named name: String, targetSize: CGSize) -> UIImage? {
        if let cached = cache.image(forKey: "\(name)-\(Int(targetSize.width))x\(Int(targetSize.height))") { return cached }
        guard let url = Bundle.main.url(forResource: name, withExtension: nil),
              let src = CGImageSourceCreateWithURL(url as CFURL, nil) else { return nil }
        let image = Downsample.downsample(from: src, to: targetSize, scale: UIScreen.main.scale)
        if let image { cache.setImage(image, forKey: "\(name)-\(Int(targetSize.width))x\(Int(targetSize.height))") }
        return image
    }
}
