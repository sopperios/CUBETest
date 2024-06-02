//
//  Attractions.swift
//  CUBETest
//
//  Created by Mint on 2024/6/1.
//

import Foundation

struct Category: Codable {
    let id: Int
    let name: String
}

struct Target: Codable {
    let id: Int
    let name: String
}

struct Service: Codable {
    let id: Int
    let name: String
}

struct Friendly: Codable {
    let id: Int
    let name: String
}

struct Image: Codable {
    let src: String
    let subject: String
    let ext: String
}

struct Attraction: Codable {
    let id: Int
    let name: String
    let name_zh: String?
    let open_status: Int
    let introduction: String
    let open_time: String
    let zipcode: String
    let distric: String
    let address: String
    let tel: String
    let fax: String
    let email: String
    let months: String
    let nlat: Double
    let elong: Double
    let official_site: String
    let facebook: String
    let ticket: String
    let remind: String
    let staytime: String
    let modified: String
    let url: String
    let category: [Category]
    let target: [Target]
    let service: [Service]
    let friendly: [Friendly]
    let images: [Image]
}

struct Attractions: Codable {
    let total: Int
    let data: [Attraction]
}
