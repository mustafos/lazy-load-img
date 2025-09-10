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
            if let image { Image(uiImage: image).resizable().scaledToFill() }
            else { Rectangle().opacity(0.08).overlay(ProgressView()) }
        }
        .onAppear {
            if image == nil {
                image = loader.loadBundledImage(named: name, targetSize: targetSize)
            }
        }
        .clipped()
    }
}
