//
//  ListingsPresenter.swift
//  ListingsApp
//
//  Created by Christie Davis on 5/08/19.
//  Copyright © 2019 Christie-Davis. All rights reserved.
//

import UIKit
import PromiseKit

protocol ListingsPresenterProcotocol {
    func numRows() -> Int
    func jobForRow(_ row: Int) -> JobDTO?
    func selectRow(_ row: Int)
}

class ListingsPresenter: BasePresenter {
    
    weak var view: ListingsViewController?
    weak var coordinator: AppCoordinatorDelegate?
    
    var jobList: [JobDTO] = []
}

extension ListingsPresenter: ListingsPresenterProcotocol {
    func load() {
        _ = self.serviceFactory.getJobs()
            .done { [weak self] (jobList) in
                self?.jobList = jobList.list?.sorted(by: { $0.listingId ?? 0 < $1.listingId ?? 0 }) ?? [] // TODO: This is not an overly relevant way to sort these,but allows for consistency betweeen online/offline
                self?.view?.reloadView()
            }
            .catch { (error) in
                print(error)
        }
        
    }
    
    func numRows() -> Int {
        return jobList.count
    }
    
    func jobForRow(_ row: Int) -> JobDTO? {
        if row >= 0 && row < jobList.count {
            return jobList[row]
        }
        return nil
    }
    
    func selectRow(_ row: Int) {
        if let job = self.jobForRow(row) {
            self.coordinator?.goToJobDetails(job)
        }
    }
}
