//
//  DataService.swift
//  ListingsApp
//
//  Created by Christie Davis on 5/08/19.
//  Copyright © 2019 Christie-Davis. All rights reserved.
//

import UIKit

protocol DataServiceProtocol: class {
    func getJobs() -> [JobDTO]
}

class DataService {

}

extension DataService: DataServiceProtocol {
    func getJobs() -> [JobDTO] {
//        let jobs: [Job]? = Job.lookup()
        return []
    }
}

