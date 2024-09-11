//
//  ContentView.swift
//  WebViewApp
//
//  Created by Mustafa Bekirov on 11.09.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var isLoading = true
    
    var body: some View {
        Group {
            if isLoading {
                LaunchView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            isLoading = false
                        }
                    }
            } else {
                WebViewView()
            }
        }
    }
}
