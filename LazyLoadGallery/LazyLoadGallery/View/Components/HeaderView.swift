//
//  HeaderView.swift
//  LazyLoadGallery
//
//  Created by Mustafa Bekirov on 10.09.2025.
//

import SwiftUI

struct HeaderView: View {
    let appName: String
    var rightIcon: String = "bell"
    
    var body: some View {
        ZStack {
            Text(appName)
                .font(.title2.bold())
                .foregroundColor(.primary)
            
            HStack {
                Spacer()
                Button {
                    // action
                } label: {
                    Image(systemName: rightIcon)
                        .font(.title3.weight(.semibold))
                        .foregroundColor(.primary)
                }
            }
            .padding(.trailing, 16)
        }
        .padding(.vertical, 12)
        .background(Color.white.ignoresSafeArea(edges: .top))
    }
}
