//
//  ImageLoader.swift
//  LazyLoadGallery
//
//  Created by Mustafa Bekirov on 10.09.2025.
//

import UIKit
import ImageIO

final class ImageLoader {
    private let cache: ImageCaching
    init(cache: ImageCaching = ImageCache.shared) { self.cache = cache }

    func loadBundledImage(named name: String, targetSize: CGSize) -> UIImage? {
        let cacheKey = "\(name)-\(Int(targetSize.width))x\(Int(targetSize.height))"
        if let cached = cache.image(forKey: cacheKey) { return cached }

        // Try file in bundle first
        if let url = urlForResourceLike(name),
           let src = CGImageSourceCreateWithURL(url as CFURL, nil),
           let img = Downsample.downsample(from: src, to: targetSize, scale: UIScreen.main.scale) {
            cache.setImage(img, forKey: cacheKey)
            return img
        }

        // Fallback to asset catalog (strip extension)
        let baseName = (name as NSString).deletingPathExtension
        if let ui = UIImage(named: baseName) {
            if let data = ui.pngData() ?? ui.jpegData(compressionQuality: 0.95),
               let src = CGImageSourceCreateWithData(data as CFData, nil),
               let img = Downsample.downsample(from: src, to: targetSize, scale: UIScreen.main.scale) {
                cache.setImage(img, forKey: cacheKey)
                return img
            } else {
                cache.setImage(ui, forKey: cacheKey)
                return ui
            }
        }

        return nil
    }

    private func urlForResourceLike(_ name: String) -> URL? {
        let base = (name as NSString).deletingPathExtension
        let ext  = (name as NSString).pathExtension
        if ext.isEmpty {
            for e in ["jpg", "jpeg", "png", "heic"] {
                if let url = Bundle.main.url(forResource: base, withExtension: e) { return url }
            }
            return nil
        } else {
            return Bundle.main.url(forResource: base, withExtension: ext)
        }
    }
}
