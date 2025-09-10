//
//  MediaPagerView.swift
//  LazyLoadGallery
//
//  Created by Mustafa Bekirov on 10.09.2025.
//

import SwiftUI

struct MediaPagerView: View {
    let photoName: String
    let videoName: String
    let visibleRatio: CGFloat
    @Binding var isMuted: Bool
    
    @State private var page = 0
    
    var body: some View {
        TabView(selection: $page) {
            PhotoView(
                name: photoName,
                targetSize: CGSize(width: UIScreen.main.bounds.width - 32,
                                   height: (UIScreen.main.bounds.width - 32) * 0.75)
            )
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.corner, style: .continuous))
            .tag(0)
            
            VideoPlayerCard(
                name: videoName,
                shouldPlay: (page == 1) && (visibleRatio >= 0.25),
                isMuted: $isMuted
            )
            .tag(1)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .frame(maxWidth: .infinity)
    }
}
