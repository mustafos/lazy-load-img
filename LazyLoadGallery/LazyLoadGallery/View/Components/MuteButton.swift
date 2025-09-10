//
//  MuteButton.swift
//  LazyLoadGallery
//
//  Created by Mustafa Bekirov on 10.09.2025.
//

import SwiftUI

struct MuteButton: View {
    @Binding var isMuted: Bool
    @State private var pulse = false

    var body: some View {
        Button {
            isMuted.toggle()
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            withAnimation(.easeOut(duration: 0.35)) {
                pulse.toggle()
            }
        } label: {
            ZStack {
                Circle()
                    .strokeBorder(.white.opacity(0.6), lineWidth: 1)
                    .scaleEffect(pulse ? 1.15 : 1.0)
                    .opacity(pulse ? 0.0 : 0.8)

                Circle()
                    .fill(.ultraThinMaterial)
                    .overlay(
                        Circle()
                            .fill(LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.black.opacity(0.25),
                                    Color.black.opacity(0.10)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .opacity(0.25)
                    )

                Image(systemName: isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 2)
                    .scaleEffect(isMuted ? 0.95 : 1.05)
                    .animation(.spring(response: 0.25, dampingFraction: 0.7), value: isMuted)
            }
            .frame(width: 34, height: 34)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(isMuted ? "Muted" : "Unmuted")
        .accessibilityAddTraits(.isButton)
    }
}
