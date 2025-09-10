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
                    .scaledToFit()
                    .frame(maxWidth: .infinity, alignment: .center)
            } else {
                Rectangle()
                    .fill(Color.secondary.opacity(0.08))
                    .overlay(ProgressView())
                    .aspectRatio(4/3, contentMode: .fit)
            }
        }
        .onAppear {
            if image == nil {
                image = loader.loadBundledImage(named: name, targetSize: targetSize)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .contentShape(Rectangle())
    }
}
