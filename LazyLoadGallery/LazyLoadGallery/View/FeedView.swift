//
//  FeedView.swift
//  LazyLoadGallery
//
//  Created by Mustafa Bekirov on 28.05.2024.
//

import SwiftUI

struct FeedView: View {
    @StateObject var vm = FeedViewModel()
    @State private var vis: [UUID: CGFloat] = [:]

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 0) {
                HeaderView(appName: "Feed")
                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(vm.posts) { cellVM in
                            PostCell(vm: cellVM,
                                     visibleRatio: vis[cellVM.id] ?? 0)
                                .reportVisibility(id: cellVM.id)
                        }
                    }
                    .padding(.vertical, 8)
                }
                .scrollIndicators(.hidden)
                .onPreferenceChange(VisibilityKey.self) { vis = $0 }
                .onAppear {
                    vm.preheatImages(screenWidth: UIScreen.main.bounds.width)
                    vm.preheatVideos()
                }
                .refreshable {
                    vm.preheatImages(screenWidth: UIScreen.main.bounds.width)
                    vm.preheatVideos()
                }
            }
            .background(AppTheme.bg.ignoresSafeArea())

            GradientFAB()
        }
        .background(AppTheme.bg.ignoresSafeArea())
        .onAppear {
            vm.preheatImages(screenWidth: UIScreen.main.bounds.width)
            vm.preheatVideos()
        }
    }
}
