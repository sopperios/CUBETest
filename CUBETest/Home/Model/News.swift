//
//  News.swift
//  CUBETest
//
//  Created by Mint on 2024/6/1.
//

import Foundation

struct Link: Codable {
    let src: String
    let subject: String
}

struct File: Codable {
    let src: String
    let subject: String
    let ext: String
}

struct New: Codable {
    let id: Int
    let title: String
    let description: String?
    let begin: Int?
    let end: String?
    let posted: String
    let modified: String
    let url: String
    let files: [File]
    let links: [Link]
}

struct News: Codable {
    let total: Int
    let data: [New]
}
