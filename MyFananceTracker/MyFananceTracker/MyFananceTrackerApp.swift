//
//  MyFananceTrackerApp.swift
//  MyFananceTracker
//
//  Created by Vitya Mandryk on 27.11.2024.
//

import SwiftUI
import UIKit
import FBSDKCoreKit
import AppTrackingTransparency

@main
struct MyFinanceTrackerApp: App {
    @StateObject private var viewModel = WebViewModel()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            Group {
                if viewModel.showContentView {
                    ContentView()
                } else if let url = viewModel.webViewURL {
                    WebView(url: url)
                }
            }
            .onAppear {
                showATTAlert()
                viewModel.fetchWebViewData()
            }
        }
    }
    
    private func showATTAlert() {
        if #available(iOS 14, *) {
            let status = ATTrackingManager.trackingAuthorizationStatus
            if status != .authorized {
                let alert = UIAlertController(
                    title: "Enable Tracking",
                    message: "We use tracking to provide a better experience and personalized ads. Please allow tracking to support our app's development.",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "Allow", style: .default, handler: { _ in
                    requestTrackingPermission()
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let rootVC = windowScene.windows.first?.rootViewController {
                    rootVC.present(alert, animated: true, completion: nil)
                }
            } else {
                print("Tracking permission already determined: \(status.rawValue)")
            }
        }
    }

    
    private func requestTrackingPermission() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized:
                    print("Tracking authorized.")
                case .denied, .restricted:
                    print("Tracking denied or restricted.")
                case .notDetermined:
                    print("Tracking not determined.")
                @unknown default:
                    print("Unknown ATT status.")
                }
            }
        }
    }
}

// MARK: - AppDelegate for Facebook SDK Integration
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        print("Facebook SDK initialized.")
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
    }
}
