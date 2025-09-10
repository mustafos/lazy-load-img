//
//  MuteButton.swift
//  LazyLoadGallery
//
//  Created by Mustafa Bekirov on 10.09.2025.
//

import SwiftUI

struct MuteButton: View {
    @Binding var isMuted: Bool
    @State private var animate = false

    var body: some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isMuted.toggle()
                animate.toggle()
            }
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        } label: {
            Image(systemName: isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .padding(14)
                .background(.black.opacity(0.5), in: Circle())
                .overlay(
                    Circle()
                        .strokeBorder(Color.white.opacity(0.7), lineWidth: 1)
                )
                .scaleEffect(animate ? 1.2 : 1.0)
                .shadow(color: .black.opacity(0.3), radius: 6, x: 0, y: 4)
        }
        .buttonStyle(.plain)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: animate)
    }
}
