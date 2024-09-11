//
//  LoadingViewController.swift
//  WebView
//
//  Created by Mustafa Bekirov on 11.09.2024.
//

import UIKit
import AdSupport
import AppsFlyerLib

class LoadingViewController: UIViewController {

    let ballView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBallView()
        startBouncingAnimation()
        
        // Collect Advertising ID and AppsFlyer data
        collectDeviceData()
    }

    // Setup the ball's appearance
    private func setupBallView() {
        ballView.frame = CGRect(x: self.view.center.x - 25, y: self.view.center.y - 50, width: 50, height: 50)
        ballView.backgroundColor = .blue
        ballView.layer.cornerRadius = 25
        self.view.addSubview(ballView)
    }

    // Start the bouncing animation
    private func startBouncingAnimation() {
        UIView.animate(withDuration: 0.5, delay: 0, options: [.autoreverse, .repeat], animations: {
            self.ballView.frame.origin.y += 100
        }, completion: nil)
    }

    // Collecting Advertising ID and AppsFlyer data
    private func collectDeviceData() {
        // Advertising ID
        let advertisingId = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        print("Advertising ID: \(advertisingId)")
        
        // AppsFlyer Device ID and conversion data
        AppsFlyerLib.shared().start { (response, error) in
            if let error = error {
                print("AppsFlyer Error: \(error.localizedDescription)")
            } else if let response = response {
                print("AppsFlyer Data: \(response)")
            }
        }
        
        // Simulating a delay before transitioning to the WebView
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.transitionToWebView()
        }
    }

    // Transition to WebView
    private func transitionToWebView() {
        let webVC = WebViewController()
        webVC.modalTransitionStyle = .crossDissolve
        webVC.modalPresentationStyle = .fullScreen
        self.present(webVC, animated: true, completion: nil)
    }
}

