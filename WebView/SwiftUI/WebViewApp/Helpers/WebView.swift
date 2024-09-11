//
//  WebView.swift
//  WebViewApp
//
//  Created by Mustafa Bekirov on 11.09.2024.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let urlString: String
    
    func makeUIView(context: Context) -> WKWebView {
        // Creating WKWebpagePreferences to enable JavaScript
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true // Enable JavaScript in the web page
        
        // Configuring WKWebView
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences = preferences // Apply preferences for JavaScript
        configuration.websiteDataStore = WKWebsiteDataStore.default() // Enable third-party cookies
        
        // Initializing WKWebView with the specified configuration
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.allowsBackForwardNavigationGestures = true // Allow swipe gestures for back/forward navigation
        
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        // Load the provided URL if it's valid
        if let url = URL(string: urlString) {
            webView.load(URLRequest(url: url)) // Load the URL request in the web view
        }
    }
}
