//
//  moxieTests.swift
//  moxieTests
//
//  Created by Tomoki Takasawa on 12/15/17.
//  Copyright © 2017 Tomoki Takasawa. All rights reserved.
//

import XCTest
@testable import moxie

class moxieTests: XCTestCase {
    
    override func setUp() {
        super.setUp()

        let exp = expectation(description: "login")
        UserManager.shared.authenticate(email: "test5@gmail.com", password: "Password") {_ in
            exp.fulfill()
        }
        wait(for: [exp], timeout: 3.0)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformance() {
        // This is an example of a performance test case.
        let user = UserManager.shared
        let exp = expectation(description: "streak")
        var avg:UInt64 = 0
        let group = DispatchGroup()
        for _ in 0...10 {
            group.enter()
            let start = DispatchTime.now()
            user.getUsersStreak(completion: { (a, b, c, d) in
                //code
                let end = DispatchTime.now()
                avg = (avg + (end.uptimeNanoseconds - start.uptimeNanoseconds)) / 2
                group.leave()
            })
            // Put the code you want to measure the time of here.
        }
        
        group.notify(queue: .main) {
            exp.fulfill()
            print("done: \(avg / 1000000000)")
        }
        
        wait(for: [exp], timeout: 15.0)
    }
}
