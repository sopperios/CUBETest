//
//  CUBETestTests.swift
//  CUBETestTests
//
//  Created by Mint on 2024/6/1.
//

import XCTest
@testable import CUBETest

final class CUBETestTests: XCTestCase {

    var viewModel: HomeViewModel = HomeViewModel()
    
    
    func testFetchNews() {
        viewModel.fetchNews(page: 1) { error in
            XCTAssert(error == nil)
        }
    }
    
    func testFetchAttractions() {
        viewModel.fetchAttractions(page: 1){ error in
            XCTAssert(error == nil)
        }
    }
}
