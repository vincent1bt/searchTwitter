//
//  twitterSearchTests.swift
//  twitterSearchTests
//
//  Created by vicente rodriguez on 5/12/16.
//  Copyright © 2016 vicente rodriguez. All rights reserved.
//

import XCTest
@testable import twitterSearch

class twitterSearchTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetUser() {
        Data.sharedData.getUser("stevewoz") {
            (json, error) -> Void in
            XCTAssertNil(error, "Error in getUser")
            let id = json![0]["id"].object as! Int
            XCTAssertNotNil(json, "The json object is nil(getUser)")
            XCTAssertNotNil(id, "The id is nil(getUser)")
        }
    }
    
    func testGetTweets() {
        Data.sharedData.getTweets(22938914) {
            (json, error) -> Void in
            XCTAssertNil(error, "Eror in getTweets")
            let key = json![0]
            let geo: NSArray? = key["geo"]["coordinates"].object as? NSArray
            XCTAssertNotNil(json, "The json object is nil(getTweets)")
            XCTAssertNotNil(geo, "The geo object is nil(getTweets)")
            
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
