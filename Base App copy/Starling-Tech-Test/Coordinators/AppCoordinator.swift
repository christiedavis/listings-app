//
//  AppCoordinator.swift
//  Starling-Tech-Test
//
//  Created by Christie Davis on 27/07/19.
//  Copyright © 2019 Christie-Davis. All rights reserved.
//

import UIKit

protocol AppCoordinatorDelegate: class {
    func enterApp()
}

class AppCoordinator {
    
    private var window: UIWindow?
    fileprivate weak var navigationController: UINavigationController?
//    fileprivate lazy var repositoryFactory: RepositoryFactoryProtocol = RepositoryFactory.shared

}

extension AppCoordinator: AppCoordinatorDelegate {
    func enterApp() {
        window = UIWindow(frame: UIScreen.main.bounds)
        let navController = UINavigationController()
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        navigationController = navController
        
        self.goToUsersAccountView()
        // This is where we would usually have logic to detirmine where the app is going - but this a simple one vc app so it always goes the same way.
        
    }
    
    func goToUsersAccountView() {
        let viewController = UserAccountViewController()
        viewController.presenter.coordinator = self
       
        navigationController?.pushViewController(viewController, animated: true)
        
    }
}
