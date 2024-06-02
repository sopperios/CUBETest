//
//  HomeService.swift
//  CUBETest
//
//  Created by Mint on 2024/6/1.
//

import UIKit

class HomeService {
    
    let baseUrl = "https://www.travel.taipei/open-api/"
    
    func fetchAttractions(page:Int, completion: @escaping (Result<Attractions, Error>) -> Void) {
        let url = baseUrl + "\(self.getLanguage())/Attractions/All?page=" + "\(page)"
        APIManager.shared.request(url: url ) { (result: Result<Attractions, Error>) in
            switch result {
            case .success(let Attractions):
                completion(.success(Attractions))
            case .failure(let error):
                completion(.failure(error))
                print("Error: \(error)")
            }
        }
    }
    
    func fetchNews(page:Int, completion: @escaping (Result<News, Error>) -> Void) {
        let url = baseUrl + "\(self.getLanguage())/Events/News?page=" + "\(page)"
        APIManager.shared.request(url: url ) { (result: Result<News, Error>) in
            switch result {
            case .success(let Attractions):
                completion(.success(Attractions))
            case .failure(let error):
                completion(.failure(error))
                print("Error: \(error)")
            }
        }
    }
    
    private func getLanguage() -> String {
        guard let value = UserDefaults.standard.string(forKey: "language"), let jsonData = value.data(using: .utf8),let language = try? JSONDecoder().decode(Language.self, from: jsonData) else{ return "zh-tw" }
        return language.value
    }
    
}

