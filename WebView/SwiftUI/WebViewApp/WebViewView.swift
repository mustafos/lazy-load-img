//
//  WebViewView.swift
//  WebViewApp
//
//  Created by Mustafa Bekirov on 11.09.2024.
//

import SwiftUI
import AdSupport
import AppsFlyerLib

struct WebViewView: View {
    @State private var urlString: String = ""
    @State private var advertisingId: String = ""
    @State private var appsflyerId: String = ""
    @State private var conversionData: [String: Any] = [:]
    
    var body: some View {
        VStack {
            TextField("Enter URL", text: $urlString)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onSubmit {
                    let requestBody = createRequestBody(
                        url: urlString,
                        advertisingId: advertisingId,
                        appsflyerId: appsflyerId,
                        conversionData: conversionData
                    )
                    
                    print("Request Body: \(requestBody)") // Debug: printing the request body for verification
                    
                    hideKeyboard() // Hide the keyboard after URL submission
                }
            
            WebView(urlString: urlString)
                .edgesIgnoringSafeArea(.all) // Ensuring the WebView uses the entire screen
        }
        .onAppear {
            collectDeviceData() // Gathering device data when the view appears
        }
    }
    
    // Function to create a request body with URL and device info
    func createRequestBody(url: String, advertisingId: String, appsflyerId: String, conversionData: [String: Any]) -> [String: Any] {
        return [
            "url": url,
            "advertisingId": advertisingId,
            "appsflyerId": appsflyerId,
            "conversionData": conversionData,
            "appId": Config.appId,
            "uniqueKey": Config.uniqueKey
        ]
    }
    
    // Collect device data like Advertising ID and AppsFlyer details
    func collectDeviceData() {
        advertisingId = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        
        AppsFlyerLib.shared().start { response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)") // Log an error if AppsFlyer fails
            } else if let response = response {
                appsflyerId = response["appsflyer_id"] as? String ?? "" // Extract AppsFlyer ID
                conversionData = response // Store the conversion data
                print("Appsflyer Data: \(conversionData)") // Debug: print the collected data
            }
        }
        
        print("Advertising ID: \(advertisingId)") // Debug: print the Advertising ID
    }
    
    // Function to hide the keyboard
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
