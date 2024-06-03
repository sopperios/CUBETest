//
//  HomeViewModel.swift
//  CUBETest
//
//  Created by Mint on 2024/6/1.
//

import Foundation
class HomeViewModel {
    private var homeService: HomeService
    var attractions:[Attraction] = []
    var news:[New] = []

    init(homeService: HomeService = HomeService()) {
        self.homeService = homeService
    }
    
    func fetchAttractions(page:Int,completion: @escaping (Error?) -> Void) {
        homeService.fetchAttractions(page: page) { result in
            switch result {
            case .success(let attractions):
                self.attractions = attractions.data
                print(self.attractions)
            case .failure(let error):
                self.attractions = []
                completion(error)
                print("Error fetching users: \(error)")
            }
            completion(nil)
        }
    }
    
    func fetchNews(page:Int,completion: @escaping (Error?) -> Void) {
        homeService.fetchNews(page: page) { result in
            switch result {
            case .success(let news):
                self.news = news.data
                print(self.news)
            case .failure(let error):
                self.news = []
                completion(error)
                print("Error fetching users: \(error)")
            }
            completion(nil)
        }
    }
}
    
