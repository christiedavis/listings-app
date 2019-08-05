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
    
}

class ListingsPresenter: BasePresenter {
    
    weak var view: ListingsViewController?
    weak var coordinator: AppCoordinatorDelegate?
}

extension ListingsPresenter: ListingsPresenterProcotocol {
    func load() {
        _ = self.serviceFactory.getJobs()
            .done { [weak self] (jobList) in
                print(jobList)
            }
            .catch { (error) in
                print(error)
        }
        
    }
}
