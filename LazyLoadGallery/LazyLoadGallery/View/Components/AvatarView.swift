//
//  AvatarView.swift
//  LazyLoadGallery
//
//  Created by Mustafa Bekirov on 10.09.2025.
//

import SwiftUI

struct AvatarView: View {
    let initials: String
    let size: CGFloat
    var verified: Bool = true

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Circle()
                .fill(Color.blue.opacity(0.12))
                .frame(width: size, height: size)
                .overlay(Text(initials).font(.headline))
            if verified {
                Circle()
                    .fill(Color.green)
                    .frame(width: size*0.28, height: size*0.28)
                    .overlay(Image(systemName: "checkmark.seal.fill").font(.system(size: size*0.16)).foregroundColor(.white))
                    .offset(x: 2, y: 2)
            }
        }
    }
}
