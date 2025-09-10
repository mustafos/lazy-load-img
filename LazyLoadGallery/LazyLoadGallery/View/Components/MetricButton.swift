//
//  MetricButton.swift
//  LazyLoadGallery
//
//  Created by Mustafa Bekirov on 10.09.2025.
//

import SwiftUI

struct MetricButton: View {
    let system: String
    let title: String
    var activeColor: Color? = nil
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: system)
                Text(title)
            }
            .font(.subheadline.weight(.semibold))
            .foregroundColor(activeColor ?? AppTheme.textSecondary)
            .padding(.vertical, 8)
            .padding(.horizontal, 10)
            .background(Color.clear)
            .contentShape(Rectangle())
        }
    }
}
