//
//  WebViewController.swift
//  WebView
//
//  Created by Mustafa Bekirov on 11.09.2024.
//

import UIKit
import WebKit

class WebViewController: UIViewController, UITextFieldDelegate, WKNavigationDelegate {

    var webView: WKWebView!
    let urlTextField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupWebView()
        setupTextField()
    }

    // Setup WKWebView
    private func setupWebView() {
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        configuration.websiteDataStore = .default() // Enable cookies

        webView = WKWebView(frame: self.view.bounds, configuration: configuration)
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)

        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            webView.leftAnchor.constraint(equalTo: view.leftAnchor),
            webView.rightAnchor.constraint(equalTo: view.rightAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // Setup URL input text field
    private func setupTextField() {
        urlTextField.borderStyle = .roundedRect
        urlTextField.placeholder = "Enter URL"
        urlTextField.delegate = self
        urlTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(urlTextField)

        NSLayoutConstraint.activate([
            urlTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            urlTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            urlTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            urlTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    // Handle URL input submission
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let urlString = textField.text, let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        textField.resignFirstResponder()
        return true
    }
}
