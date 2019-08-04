//
//  NetworkService.swift
//  ListingsApp
//
//  Created by Christie Davis on 4/08/19.
//  Copyright © 2019 Christie-Davis. All rights reserved.
//

import Foundation
import PromiseKit

protocol JobNetworkServiceProtocol: class {
    func getJobs() -> Promise<[JobDTO]>
}

class JobNetworkService: BaseNetworkService {
    private let accountsPath = "/accounts"
    private var transactionFeedPath = "/feed/account/012b2ab8-d0f4-4aa3-ab8e-028fabbd228f/category/75ffc012-5854-4735-8ba5-810a2992b104"
}

extension JobNetworkService: JobNetworkServiceProtocol {
    func getJobs() -> Promise<[JobDTO]> {
        
    }
}
