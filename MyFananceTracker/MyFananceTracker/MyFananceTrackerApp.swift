//
//  MyFananceTrackerApp.swift
//  MyFananceTracker
//
//  Created by Vitya Mandryk on 27.11.2024.
//

import SwiftUI

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
}

