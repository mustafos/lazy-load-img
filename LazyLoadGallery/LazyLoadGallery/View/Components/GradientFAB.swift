//
//  GradientFAB.swift
//  LazyLoadGallery
//
//  Created by Mustafa Bekirov on 10.09.2025.
//

import SwiftUI

struct GradientFAB: View {
    @State private var rotated = false
    
    var body: some View {
        Button {
            withAnimation(.spring(response: 0.45, dampingFraction: 0.65)) {
                rotated.toggle()
            }
        } label: {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.purple, Color.blue]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 56, height: 56)
                    .shadow(color: Color.blue.opacity(0.35), radius: 16, x: 0, y: 8)
                
                Image(systemName: "plus")
                    .font(.title2.bold())
                    .foregroundColor(.white)
                    .rotationEffect(.degrees(rotated ? 45 : 0))
                    .animation(.spring(response: 0.45, dampingFraction: 0.65), value: rotated)
            }
        }
        .buttonStyle(.plain)
        .padding(.trailing, 22)
        .padding(.bottom, 22)
    }
}
