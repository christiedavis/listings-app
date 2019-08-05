//
//  JobCollectionDTO.swift
//  ListingsApp
//
//  Created by Christie Davis on 5/08/19.
//  Copyright © 2019 Christie-Davis. All rights reserved.
//

import UIKit

class JobCollectionDTO: Codable {
    var list: [JobDTO]?
    
    enum CodingKeys: String, CodingKey {
        case list = "List"
    }
}
