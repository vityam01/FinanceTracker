//
//  WebViewModel.swift
//  MyFananceTracker
//
//  Created by Vitya Mandryk on 03.12.2024.
//

import Foundation
import Combine

class WebViewModel: ObservableObject {
    @Published var showContentView = false
    @Published var webViewURL: URL?

    private var cancellables = Set<AnyCancellable>()

    func fetchWebViewData() {
        let packageName = "com.financeapp.myfinancetracker"
        let appName = "ExpenseFinanceCalculator"
        let apiKey = "azewPB4bzAd5uSjlJPCTcxwau2i1zvM"
        let urlString = "https://g7-crm.com/rest/application/ios?id=\(packageName)&name=\(appName)&key=\(apiKey)"

        print("Requesting URL: \(urlString)")

        APIManager.shared.request(urlString: urlString) { [weak self] result in
            switch result {
            case .success(let data):
                self?.handleResponse(data: data)
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showContentView = true
                }
                print("Error fetching data: \(error.localizedDescription)")
            }
        }
    }

    private func handleResponse(data: Data) {
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                print("Response JSON: \(json)")

                if let status = json["status"] as? String, status == "success", let id = json["id"] as? String, !id.isEmpty {
                    if let decodedData = Data(base64Encoded: id), let decodedString = String(data: decodedData, encoding: .utf8), let url = URL(string: decodedString) {
                        DispatchQueue.main.async {
                            self.webViewURL = url
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.showContentView = true
                        }
                        print("Failed to decode Base64 or invalid URL")
                    }
                } else {
                    DispatchQueue.main.async {
                        self.showContentView = true
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.showContentView = true
                }
                print("Invalid JSON response")
            }
        } catch {
            DispatchQueue.main.async {
                self.showContentView = true
            }
            print("Error decoding JSON: \(error.localizedDescription)")
        }
    }
}
