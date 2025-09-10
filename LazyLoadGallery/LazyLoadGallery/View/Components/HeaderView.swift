//
//  HeaderView.swift
//  LazyLoadGallery
//
//  Created by Mustafa Bekirov on 10.09.2025.
//

import SwiftUI

struct HeaderView: View {
    let appName: String
    
    var body: some View {
        ZStack {
            Text(appName)
                .font(.title2.bold())
                .foregroundColor(.primary)
            
            HStack {
                Spacer()
                RingingBellButton()
            }
            .padding(.trailing, 16)
        }
        .padding(.vertical, 12)
        .background(Color.white.ignoresSafeArea(edges: .top))
    }
}
