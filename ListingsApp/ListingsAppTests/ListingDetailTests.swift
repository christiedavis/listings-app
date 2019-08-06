//
//  ListingDetailTests.swift
//  ListingsAppTests
//
//  Created by Christie Davis on 6/08/19.
//  Copyright © 2019 Christie-Davis. All rights reserved.
//

import XCTest
@testable import ListingsApp
import PromiseKit

class ListingDetailTests: XCTestCase {
    let presenter = JobDetailPresenter(serviceFactory: MockServiceFactory())

    func testScreenTitle() {
        XCTAssert(presenter.screenTitle.contains("error"))
        
        self.presenter.job = JobDTO(listingId: nil, title: "Astronaut", body: nil, jobLocation: nil, jobType: nil, company: nil, instructions: nil, applicationDetails: nil)
        
        XCTAssert(self.presenter.screenTitle.contains("Astronaut"))
    }
    
    func testJobAction() {
        XCTAssertNil(self.presenter.getJobAction())
        XCTAssertNil(self.presenter.jobDisplay)
        
        self.presenter.job = JobDTO(listingId: nil, title: "Astronaut", body: nil, jobLocation: nil, jobType: nil, company: nil, instructions: nil, applicationDetails: JobApplicationDetailsDTO(applicationType: nil, contactName: nil, website: "www.alphero.com"))
        
        XCTAssertNotNil(self.presenter.getJobAction())
        XCTAssertNotNil(self.presenter.jobDisplay)
        
        self.presenter.job = JobDTO(listingId: nil, title: "Astronaut", body: nil, jobLocation: nil, jobType: nil, company: nil, instructions: nil, applicationDetails: JobApplicationDetailsDTO(applicationType: nil, contactName: nil, website: "----t-rrt4$%^*@&)(#_@{}:@@@@"))

        XCTAssertNil(self.presenter.getJobAction())

    }
    
    func testUsableURL() {
        
        XCTAssertFalse(presenter.shouldDisplayApplyButton())
        
        self.presenter.job = JobDTO(listingId: nil, title: "Astronaut", body: nil, jobLocation: nil, jobType: nil, company: nil, instructions: nil, applicationDetails: JobApplicationDetailsDTO(applicationType: nil, contactName: nil, website: "-christie"))
        
        XCTAssertFalse(presenter.shouldDisplayApplyButton())
        self.presenter.job = JobDTO(listingId: nil, title: "Astronaut", body: nil, jobLocation: nil, jobType: nil, company: nil, instructions: nil, applicationDetails: JobApplicationDetailsDTO(applicationType: nil, contactName: nil, website: "https://www.alphero.com"))

        XCTAssert(presenter.shouldDisplayApplyButton())
    }
}
