//
//  MyFananceTrackerApp.swift
//  MyFananceTracker
//
//  Created by Vitya Mandryk on 27.11.2024.
//

import SwiftUI
import UIKit
import FBSDKCoreKit


@main
struct MyFananceTrackerApp: App {
    @StateObject private var viewModel = WebViewModel()
    
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
                viewModel.fetchWebViewData()
            }
        }
    }
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
                     ) -> Bool
    {
      Settings.shared.appID = "1146626893836078"

      ApplicationDelegate.shared.application(application,didFinishLaunchingWithOptions: launchOptions)
      return true
    }
    

    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]
                     ) -> Bool
    {
      ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
        annotation: options[UIApplication.OpenURLOptionsKey.annotation]
      )
    }
    
    
}
