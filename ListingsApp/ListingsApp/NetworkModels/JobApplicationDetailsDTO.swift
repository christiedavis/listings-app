//
//  JobApplicationDetailsDTO.swift
//  ListingsApp
//
//  Created by Christie Davis on 5/08/19.
//  Copyright © 2019 Christie-Davis. All rights reserved.
//

import UIKit

struct JobApplicationDetailsDTO: Codable {
    var applicationType: Int?
    var contactName: String?
    var website: String?
    
    enum CodingKeys: String, CodingKey {
        case applicationType = "OnlineApplicationType"
        case contactName = "ContactName"
        case website = "Website"
    }
}
