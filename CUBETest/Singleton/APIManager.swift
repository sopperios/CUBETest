//
//  APIManager.swift
//  CUBETest
//
//  Created by Mint on 2024/6/1.
//

import UIKit

class APIManager {
    static let shared = APIManager()
    
    func request<T: Decodable>(url: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(NSError(domain: "Url Error", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        let headers = [
            "Accept": "application/json",
        ]
        headers.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                return
            }
            do {
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedObject))
            } catch let decodingError {
                completion(.failure(decodingError))
            }
        }.resume()
    }
}
