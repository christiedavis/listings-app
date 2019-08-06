//
//  ManagedObjectExtension.swift
//  ListingsApp
//
//  Created by Christie Davis on 6/08/19.
//  Copyright © 2019 Christie-Davis. All rights reserved.
//

import CoreData
import PromiseKit

extension NSManagedObject {
    
    class func lookup<T>(byIdentifier identifier: String) -> T? where T: NSFetchRequestResult {
        let lookupAssetPredicate = NSPredicate(format: "identifier = %@", identifier)
        let assetFetchRequest: NSFetchRequest<T> = T.fetchRequest()
        assetFetchRequest.predicate = lookupAssetPredicate
        
        let fetchedAssets = try? PersistenceHelper.shared().managedObjectContext().fetch(assetFetchRequest) as [T]
        return fetchedAssets?.first
    }

    class func lookup<T>() -> [T]? where T: NSFetchRequestResult {
        let fetchRequest: NSFetchRequest<T> = T.fetchRequest()
        return try? PersistenceHelper.shared().managedObjectContext().fetch(fetchRequest) as [T]
    }
}

extension NSFetchRequestResult {
    
    public static func fetchRequest<T>() -> NSFetchRequest<T> where T: NSFetchRequestResult {
        return NSFetchRequest<T>(entityName: String(describing: T.self))
    }
}
