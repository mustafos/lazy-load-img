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
                        .preference(key: VisibilityKey.self,
                                    value: [id: verticalVisibleRatio(in: geo)])
                }
            )
            .transaction { $0.disablesAnimations = true }
    }
    
    private func verticalVisibleRatio(in geo: GeometryProxy) -> CGFloat {
        let frame = geo.frame(in: .global)
        let screen = UIScreen.main.bounds
        let intersection = frame.intersection(screen)
        guard frame.height > 0 else { return 0 }
        
        let ratio = max(0, min(1, intersection.height / frame.height))
        return (ratio * 20).rounded() / 20
    }
}

extension View {
    func reportVisibility(id: UUID) -> some View { modifier(VisibilityReporter(id: id)) }
}
