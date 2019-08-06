//
//  JobDetailPresenter.swift
//  ListingsApp
//
//  Created by Christie Davis on 6/08/19.
//  Copyright © 2019 Christie-Davis. All rights reserved.
//

import UIKit
import SafariServices

protocol JobDetailPresenterProtocol {
    var jobDisplay: JobDTO? { get }
    var screenTitle: String { get }
    
    func shouldDisplayApplyButton() -> Bool
    func applyTapped()
}


class JobDetailPresenter: BasePresenter {
    
    weak var view: JobDetailsViewController?
    weak var coordinator: AppCoordinatorDelegate?
    
    var job: JobDTO?
}
    
extension JobDetailPresenter: JobDetailPresenterProtocol {
    var jobDisplay: JobDTO? {
        return self.job
    }
    
    func load() {
    }
    
    var screenTitle: String {
        if let jobTitle = self.job?.title {
            return jobTitle
        } else {
            return "There has been an error loading this screen"
        }
    }
    
    func shouldDisplayApplyButton() -> Bool {
       
        if let url = self.getJobAction() {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }
    
    func applyTapped() {
        // I'd like to extend this by making it only show the button if you can open the url
        
        if let url = self.getJobAction() {
            
            let svc = SFSafariViewController(url: url)
            svc.modalPresentationStyle = .overFullScreen
            self.view?.navigationController?.present(svc, animated: true, completion: nil)
        }
    }
    
    func getJobAction() -> URL? {
        if let website = self.job?.applicationDetails?.website {
            guard let url = URL(string: website) else {
                return nil
            }
            return url
        }
        return nil
    }
}
