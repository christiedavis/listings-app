//
//  AppCoordinator.swift
//  ListingsApp
//
//  Created by Christie Davis on 5/08/19.
//  Copyright © 2019 Christie-Davis. All rights reserved.
//

import UIKit

protocol AppCoordinatorDelegate: class {
    func enterApp()
    
    func goToJobDetails(_ job: JobDTO)
}

class AppCoordinator {
    
    private var window: UIWindow?
    fileprivate weak var navigationController: UINavigationController?
}

extension AppCoordinator: AppCoordinatorDelegate {
    func enterApp() {
        window = UIWindow(frame: UIScreen.main.bounds)
        let navController = UINavigationController()
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        navigationController = navController
        
        self.goToAllListingsView()
        // This is where we would usually have logic to detirmine where the app is going - but this a simple one vc app so it always goes the same way.
    }
    
    func goToAllListingsView() {
        let viewController = ListingsViewController()
        viewController.presenter.coordinator = self
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func goToJobDetails(_ job: JobDTO) {
        let viewController = JobDetailsViewController()
        viewController.presenter.coordinator = self
        viewController.presenter.job = job
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}
