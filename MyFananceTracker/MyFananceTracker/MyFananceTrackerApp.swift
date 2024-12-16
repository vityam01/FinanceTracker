//
//  MyFananceTrackerApp.swift
//  MyFananceTracker
//
//  Created by Vitya Mandryk on 27.11.2024.
//

import SwiftUI
import UIKit
import FBSDKCoreKit
import FacebookCore
import FacebookAEM
import AppTrackingTransparency
import AdSupport

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
                requestTrackingPermission()
                viewModel.fetchWebViewData()
            }
        }
    }
    
    private func requestTrackingPermission() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized:
                    print("Tracking authorized.")
                case .denied:
                    print("Tracking denied.")
                case .restricted:
                    print("Tracking restricted.")
                case .notDetermined:
                    print("Tracking not determined.")
                @unknown default:
                    print("Unknown tracking status.")
                }
            }
        } else {
            print("ATT is not available on this iOS version.")
        }
    }
}

// MARK: - AppDelegate for Facebook SDK Integration
class AppDelegate: NSObject, UIApplicationDelegate {
    func application( _ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        return true
    }

    func application( _ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation])
    }
}
