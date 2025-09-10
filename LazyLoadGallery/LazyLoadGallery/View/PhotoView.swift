//
//  PhotoView.swift
//  LazyLoadGallery
//
//  Created by Mustafa Bekirov on 10.09.2025.
//

import SwiftUI

struct PhotoView: View {
    let name: String
    let targetSize: CGSize
    @State private var image: UIImage?
    private let loader = ImageLoader()
    
    var body: some View {
        Group {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: targetSize.width, height: targetSize.height)
                    .clipped()
            } else {
                RoundedRectangle(cornerRadius: AppTheme.corner)
                    .fill(Color.secondary.opacity(0.08))
                    .overlay(ProgressView())
                    .frame(width: targetSize.width, height: targetSize.height)
            }
        }
        .onAppear {
            if image == nil {
                image = loader.loadBundledImage(named: name, targetSize: targetSize)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.corner, style: .continuous))
    }
}
