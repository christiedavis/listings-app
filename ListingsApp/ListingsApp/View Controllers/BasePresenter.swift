//
//  BasePresenter.swift
//  ListingsApp
//
//  Created by Christie Davis on 5/08/19.
//  Copyright © 2019 Christie-Davis. All rights reserved.
//

import UIKit

protocol BasePresenterProtocol: class {
    func load()
}

class BasePresenter: NSObject {
    var serviceFactory: ServiceFactoryProtocol
    
    // Dependency injection so that it is easy to swap out in testing.
    init(serviceFactory: ServiceFactoryProtocol = ServiceFactory.shared) {
        self.serviceFactory = serviceFactory
    }
}
