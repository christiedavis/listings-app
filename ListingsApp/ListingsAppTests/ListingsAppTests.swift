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
    
//    func load() {
//        _ = self.serviceFactory.getJobs()
//            .done { [weak self] (jobList) in
//                self?.jobList = jobList.list?.sorted(by: { $0.listingId ?? 0 < $1.listingId ?? 0 }) ?? [] // TODO: This is not an overly relevant way to sort these,but allows for consistency betweeen online/offline
//                self?.view?.reloadView()
//            }
//            .catch { (error) in
//                print(error)
//        }
//
//    }
    
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
    

//    func selectRow(_ row: Int) {
//        if let job = self.jobForRow(row) {
//            self.coordinator?.goToJobDetails(job)
//        }
//    }

}
//
//    
//    func testTransferMoney() {
//        let expectation = self.expectation(description: "test transfer")
//        
//        let mockView = MockUserView()
//        mockView.testTransferCallback = { result in
//            if result.contains("transferred") {
//                expectation.fulfill()
//            } else {
//                XCTFail()
//            }
//        }
//        
//        presenter.view = mockView
//        presenter.transferMoney()
//        
//        self.waitForExpectations(timeout: 400) { (error) in
//            if error != nil {
//                XCTFail("Test expectation Failed with error: \(String(describing: error))")
//            }
//        }
//    }
//    
//    func testTransferMoneyError() {
//        let expectation = self.expectation(description: "test transfer")
//        
//        let mockView = MockUserView()
//        mockView.testTransferCallback = { result in
//            if result == "Error transferring savings - try again later." {
//                expectation.fulfill()
//            } else {
//                XCTFail()
//                expectation.fulfill()
//            }
//        }
//        
//        presenter.view = mockView
//        let topUpReqeust = presenter.createTopUpRequest(roundUpVal: Double.random(in: 0...12))
//        
//        presenter.performTransfer(accountUID: "errorCode", transferUID: UUID().uuidString, savingsAccount: UUID().uuidString, topUpRequest: topUpReqeust)
//        
//        self.waitForExpectations(timeout: 400) { (error) in
//            if error != nil {
//                XCTFail("Test expectation Failed with error: \(String(describing: error))")
//            }
//        }
//    }
//    
//    func testCreateTopUpRequest() {
//        XCTAssert(presenter.createTopUpRequest(roundUpVal: 12)?.amount?.currency == "GBP")
//        XCTAssert(presenter.createTopUpRequest(roundUpVal: 12)?.amount?.minorUnits == 1200.0)
//        
//        XCTAssert(presenter.createTopUpRequest(roundUpVal: 1234)?.amount?.minorUnits == 123400.0)
//        XCTAssert(presenter.createTopUpRequest(roundUpVal: nil) == nil)
//        XCTAssert(presenter.createTopUpRequest(roundUpVal: 0)?.amount?.minorUnits == 0)
//        
//    }
//    
//    func testGetDisplayValue() {
//        XCTAssert(presenter.getDisplayValue(from: 12.3456993) == "12.35")
//        XCTAssert(presenter.getDisplayValue(from: 54) == "54.00")
//        XCTAssert(presenter.getDisplayValue(from: 0) == "0.00")
//    }
//    
//    func testCalculateItemsFromThePastWeek() {
//        
//        let feedItems = MockNetworkService.createFeedItems(number: 3)
//        XCTAssert(presenter.calculateItemsFromThePastWeek(items: feedItems) != nil)
//        XCTAssert(presenter.calculateItemsFromThePastWeek(items: []) == 0)
//        
//        var newFeedItemArray: [FeedItemDTO] = []
//        newFeedItemArray.append(FeedItemDTO(direction: "OUT",
//                                            feedItemUid: UUID().uuidString,
//                                            categoryUid: UUID().uuidString,
//                                            amount: AmountDTO(currency: "GBP", minorUnits: 1243)))
//        newFeedItemArray.append(FeedItemDTO(direction: "OUT",
//                                            feedItemUid: UUID().uuidString,
//                                            categoryUid: UUID().uuidString,
//                                            amount: AmountDTO(currency: "GBP", minorUnits: 345467)))
//        newFeedItemArray.append(FeedItemDTO(direction: "OUT",
//                                            feedItemUid: UUID().uuidString,
//                                            categoryUid: UUID().uuidString,
//                                            amount: AmountDTO(currency: "GBP", minorUnits: 19000)))
//        newFeedItemArray.append(FeedItemDTO(direction: "OUT",
//                                            feedItemUid: UUID().uuidString,
//                                            categoryUid: UUID().uuidString,
//                                            amount: AmountDTO(currency: "GBP", minorUnits: nil)))
//        newFeedItemArray.append(FeedItemDTO(direction: "OUT",
//                                            feedItemUid: UUID().uuidString,
//                                            categoryUid: UUID().uuidString,
//                                            amount: AmountDTO(currency: "GBP", minorUnits: 4409)))
//        
//        XCTAssert(presenter.calculateItemsFromThePastWeek(items: newFeedItemArray) == 3701.19)
//        
//    }
//    
//    func testRoundupItemsFromThePastWeek() {
//        
//        let feedItems = MockNetworkService.createFeedItems(number: 3)
//        XCTAssert(presenter.calculateRoundupFromThePastWeek(items: feedItems) != nil)
//        XCTAssert(presenter.calculateRoundupFromThePastWeek(items: []) == 0)
//        
//        var newFeedItemArray: [FeedItemDTO] = []
//        newFeedItemArray.append(FeedItemDTO(direction: "OUT",
//                                            feedItemUid: UUID().uuidString,
//                                            categoryUid: UUID().uuidString,
//                                            amount: AmountDTO(currency: "GBP", minorUnits: 232)))
//        newFeedItemArray.append(FeedItemDTO(direction: "OUT",
//                                            feedItemUid: UUID().uuidString,
//                                            categoryUid: UUID().uuidString,
//                                            amount: AmountDTO(currency: "GBP", minorUnits: 43)))
//        newFeedItemArray.append(FeedItemDTO(direction: "OUT",
//                                            feedItemUid: UUID().uuidString,
//                                            categoryUid: UUID().uuidString,
//                                            amount: AmountDTO(currency: "GBP", minorUnits: 0)))
//        newFeedItemArray.append(FeedItemDTO(direction: "OUT",
//                                            feedItemUid: UUID().uuidString,
//                                            categoryUid: UUID().uuidString,
//                                            amount: AmountDTO(currency: "GBP", minorUnits: nil)))
//        newFeedItemArray.append(FeedItemDTO(direction: "OUT",
//                                            feedItemUid: UUID().uuidString,
//                                            categoryUid: UUID().uuidString,
//                                            amount: AmountDTO(currency: "GBP", minorUnits: 754)))
//        newFeedItemArray.append(FeedItemDTO(direction: "IN",
//                                            feedItemUid: UUID().uuidString,
//                                            categoryUid: UUID().uuidString,
//                                            amount: AmountDTO(currency: "GBP", minorUnits: 754)))
//        
//        XCTAssert(presenter.calculateRoundupFromThePastWeek(items: newFeedItemArray) == 1.71)
//        
//    }
//    
//    func testCalculateRoundUp() {
//        XCTAssert(presenter.calculateRoundUp(from: 34.54) == 0.46)
//        XCTAssert(presenter.calculateRoundUp(from: 0) == 0.0)
//        XCTAssert(presenter.calculateRoundUp(from: 52.00) == 0.0)
//        XCTAssert(presenter.calculateRoundUp(from: nil) == nil)
//        XCTAssert(presenter.calculateRoundUp(from: 123.04) == 0.96)
//        //        XCTAssert(presenter.calculateRoundUp(from: -2.1) == 0.9) // TODO: Fix: MY logic is broken!
//        XCTAssert(presenter.calculateRoundUp(from: 98.43) == 0.57)
//    }
//    //
//    //    func testLoadUserAccounts() -> Promise<Void> {
//    //
//    //    }
//    //
//    //    func testLoadFeed(accountUID: String?, categoryUID: String?) -> Promise<Void> {
//    //
//    //    }
//}
//
//class MockUserView: UserAccountViewProtocol {
//    var testRoundUpCallback: (() -> ())?
//    var testTransferCallback: ((String) -> ())?
//    
//    func displayTotalSpent(_ totalFromPastWeek: Double?) {
//        
//    }
//    
//    func displayRoundUpVal(_ roundUp: Double?) {
//        testRoundUpCallback?()
//    }
//    
//    func showLoadingView() {
//        
//    }
//    
//    func hideLoadingView() {
//        
//    }
//    
//    func showTransferResult(resultString: String) {
//        testTransferCallback?(resultString)
//    }
//    
//    func showTransferComplete() {
//        
//    }
//}
