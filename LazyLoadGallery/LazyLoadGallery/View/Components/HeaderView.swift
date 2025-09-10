//
//  HeaderView.swift
//  LazyLoadGallery
//
//  Created by Mustafa Bekirov on 10.09.2025.
//

import SwiftUI

struct HeaderView: View {
    let title: String
    let progress: CGFloat
    
    private let maxH: CGFloat = 120
    private let minH: CGFloat = 56
    
    var body: some View {
        let h = max(minH, maxH - (maxH - minH) * progress)
        
        ZStack {
            RoundedRectangle(cornerRadius: AppTheme.corner, style: .continuous)
                .fill(AppTheme.card)
                .shadow(color: AppTheme.shadow.color, radius: AppTheme.shadow.radius, x: 0, y: AppTheme.shadow.y)
            
            HStack {
                Spacer()
                Text(title)
                    .font(.system(size: lerp(28, 18, progress), weight: .bold))
                    .foregroundColor(AppTheme.textPrimary)
                Spacer()
                Button { /* notifications */ } label: {
                    Image(systemName: "bell.fill")
                        .font(.title3)
                        .foregroundColor(AppTheme.accent)
                        .padding(10)
                }
            }
            .padding(.horizontal, 12)
        }
        .frame(height: h)
        .padding(.horizontal, 12)
        .padding(.top, 12)
    }
    
    private func lerp(_ a: CGFloat, _ b: CGFloat, _ t: CGFloat) -> CGFloat { a + (b - a) * t }
}
