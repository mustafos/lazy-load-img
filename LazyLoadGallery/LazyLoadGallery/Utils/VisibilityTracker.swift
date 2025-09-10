//
//  VisibilityTracker.swift
//  LazyLoadGallery
//
//  Created by Mustafa Bekirov on 10.09.2025.
//

import SwiftUI

struct VisibilityKey: PreferenceKey {
    static var defaultValue: [UUID: CGFloat] = [:]
    static func reduce(value: inout [UUID: CGFloat], nextValue: () -> [UUID: CGFloat]) {
        value.merge(nextValue(), uniquingKeysWith: { _, new in new })
    }
}

struct VisibilityReporter: ViewModifier {
    let id: UUID
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geo in
                    Color.clear
                        .preference(key: VisibilityKey.self, value: [id: visibleRatio(in: geo)])
                }
            )
    }
    private func visibleRatio(in geo: GeometryProxy) -> CGFloat {
        let frame = geo.frame(in: .global)
        let screen = UIScreen.main.bounds
        let intersection = frame.intersection(screen)
        guard !frame.isEmpty else { return 0 }
        return max(0, min(1, (intersection.height * intersection.width) / (frame.height * frame.width)))
    }
}

extension View {
    func reportVisibility(id: UUID) -> some View { modifier(VisibilityReporter(id: id)) }
}
