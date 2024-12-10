//
//  APIMahager.swift
//  MyFananceTracker
//
//  Created by Vitya Mandryk on 10.12.2024.
//

import Foundation



class APIManager {
    static let shared = APIManager()

    private init() {}

    enum HTTPMethod: String {
        case GET, POST, PUT, DELETE
    }

    func request(
        urlString: String,
        method: HTTPMethod = .GET,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -1, userInfo: nil)))
                return
            }

            completion(.success(data))
        }
        task.resume()
    }
}
