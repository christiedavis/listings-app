//
//  BasePresenter.swift
//  Starling-Tech-Test
//
//  Created by Christie Davis on 27/07/19.
//  Copyright © 2019 Christie-Davis. All rights reserved.
//

import Foundation

protocol BasePresenterProtocol: class {
    func load()
}

class BasePresenter: NSObject {
    var serviceFactory: ServiceFactoryProtocol
    
    init(serviceFactory: ServiceFactoryProtocol = ServiceFactory.shared) {
        self.serviceFactory = serviceFactory
    }
}
