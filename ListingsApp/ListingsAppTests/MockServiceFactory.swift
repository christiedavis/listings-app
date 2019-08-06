//
//  MockServiceFactory.swift
//  ListingsAppTests
//
//  Created by Christie Davis on 6/08/19.
//  Copyright © 2019 Christie-Davis. All rights reserved.
//

import UIKit
@testable import ListingsApp
import PromiseKit

class MockServiceFactory: ServiceFactoryProtocol {

    let mockService = MockNetworkService()

    func getJobs() -> Promise<JobCollectionDTO> {
        return mockService.getJobs()
    }
}

class MockNetworkService: JobNetworkServiceProtocol {
    func getJobs() -> Promise<JobCollectionDTO> {
        
        let collection = MockNetworkService.createMockJobCollection(numJobs: Int.random(in: 1...10))
        
        return Promise.value(collection)
    }
    
    static func createMockJobCollection(numJobs: Int) -> JobCollectionDTO {
        var jobList: [JobDTO] = []
        
        for _ in 0...numJobs {
            let id = Int.random(in: 1...100)
            let mockDto = JobDTO(listingId: id, title: "TItle \(id)", body: "body text", jobLocation: "New zealand", jobType: .fulltime, company: "pretend company", instructions: "hello, to apply for this job please email me", applicationDetails: nil)
            jobList.append(mockDto)
        }
        
        return JobCollectionDTO(jobsList: jobList)
    }
}
