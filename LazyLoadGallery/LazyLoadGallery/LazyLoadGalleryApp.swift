//
//  LazyLoadGalleryApp.swift
//  LazyLoadGallery
//
//  Created by Mustafa Bekirov on 28.05.2024.
//

import SwiftUI
import AVFAudio

@main
struct LazyLoadGalleryApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) private var phase
    
    var body: some Scene {
        WindowGroup {
            FeedView()
                .preferredColorScheme(.light)
                .onChange(of: phase) { newPhase in
                    if newPhase == .active {
                        appDelegate.configureAudioSession()
                    }
                }
        }
    }
}

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        configureAudioSession()
        return true
    }
    
    func configureAudioSession() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playback, mode: .moviePlayback, options: [])
            try session.setActive(true)
            print("✅ AudioSession active, category: \(session.category.rawValue)")
        } catch {
            print("❌ AudioSession error:", error)
        }
    }
}
