//
//  Theme.swift
//  LazyLoadGallery
//
//  Created by Mustafa Bekirov on 10.09.2025.
//

import SwiftUI

enum AppTheme {
    static let bg = Color(UIColor.systemGray6)
    static let card = Color.white
    static let accent = Color.blue
    static let like = Color.red
    static let textPrimary = Color.primary
    static let textSecondary = Color.secondary
    
    static let corner: CGFloat = 24
    static let shadow = ShadowStyle()
    struct ShadowStyle {
        let color = Color.black.opacity(0.08)
        let radius: CGFloat = 16
        let y: CGFloat = 8
    }
}
