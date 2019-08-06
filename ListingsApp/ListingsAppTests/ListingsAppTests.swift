//
//  ListingsAppTests.swift
//  ListingsAppTests
//
//  Created by Christie Davis on 4/08/19.
//  Copyright © 2019 Christie-Davis. All rights reserved.
//

import XCTest
@testable import ListingsApp
import PromiseKit

class ListingsAppTests: XCTestCase {
    let presenter = ListingsPresenter(serviceFactory: MockServiceFactory())

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
 
    func testNumRows() {
        
        let expectation = self.expectation(description: "test num rows")
        
        self.presenter.serviceFactory.getJobs()
        .done { (jobResult) in
            self.presenter.jobList = jobResult.list ?? []
            
            XCTAssert(self.presenter.numRows() == jobResult.list?.count)
             expectation.fulfill()
        }
        .catch { (error) in
                XCTFail()
                expectation.fulfill()
        }
        self.waitForExpectations(timeout: 400) { (error) in
            if error != nil {
                XCTFail("Test expectation Failed with error: \(String(describing: error))")
            }
        }
    }
    
    func testJobForRow() {
        
        let expectation = self.expectation(description: "test job for rows")
        
        self.presenter.serviceFactory.getJobs()
            .done { (jobResult) in
                self.presenter.jobList = jobResult.list ?? []
                
                let presenterRow = self.presenter.jobForRow(1)
                let hasListing = jobResult.list?.contains(where: { $0.identifier == presenterRow?.identifier })
                
                XCTAssertNil(self.presenter.jobForRow(-500))
                XCTAssertNil(self.presenter.jobForRow(jobResult.list?.count ?? 1000))
                XCTAssertTrue(hasListing ?? false)
                expectation.fulfill()
            }
            .catch { (error) in
                XCTFail()
                expectation.fulfill()
        }
        self.waitForExpectations(timeout: 400) { (error) in
            if error != nil {
                XCTFail("Test expectation Failed with error: \(String(describing: error))")
            }
        }
    }
}
