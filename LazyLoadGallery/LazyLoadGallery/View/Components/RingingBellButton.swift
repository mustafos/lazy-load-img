//
//  RingingBellButton.swift
//  LazyLoadGallery
//
//  Created by Mustafa Bekirov on 10.09.2025.
//

import SwiftUI

struct RingingBellButton: View {
    @State private var isOn = false
    @State private var angle: Double = 0
    
    var body: some View {
        Button {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            withAnimation(.spring(response: 0.28, dampingFraction: 0.7)) {
                isOn.toggle()
            }
            ringBell()
        } label: {
            Image(systemName: isOn ? "bell.fill" : "bell")
                .font(.title3.weight(.semibold))
                .foregroundColor(isOn ? .yellow : .primary)
                .rotationEffect(.degrees(angle), anchor: .top)
                .frame(width: 32, height: 32)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(isOn ? "Notifications on" : "Notifications off")
    }
    
    private func ringBell() {
        Task {
            let steps: [Double] = [18, -16, 12, -8, 4, 0]
            let dur: Double = 0.07
            for target in steps {
                await animateAngle(to: target, duration: dur)
            }
        }
    }
    
    private func animateAngle(to value: Double, duration: Double) async {
        await MainActor.run {
            withAnimation(.easeOut(duration: duration)) {
                angle = value
            }
        }
        try? await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
    }
}
