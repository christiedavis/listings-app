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

public protocol ExternalPersistenceHelperProtocol: class {
    func saveContext()
    
    static func publicShared() -> ExternalPersistenceHelperProtocol
    
    /// Loads the PersistentStores for the specified user, as each user can have their own data store on device.
    ///
    /// - Parameter forUser: the short user name to key the datatore from
    /// - Returns: a Promise containing the loaded NSPersistenceContainer or an Error
    func loadPersistentStores() -> Promise<NSPersistentContainer>
    
    func saveAndTearDownContext()
}

/// Use the PersistenceHelperProtocol when manipulating the Persistence Container from within
/// the DataAccess module.
internal protocol PersistenceHelperProtocol: class {
    var persistentContainer: NSPersistentContainer? { get }
    func managedObjectContext() -> NSManagedObjectContext
    
    /// exposes an internal shared instance used for manipulating the persistence context
    ///
    /// - Returns: a singelton PersistenceHelper instance that can be used more broadly within the DataAccess module
    static func shared() -> PersistenceHelperProtocol & ExternalPersistenceHelperProtocol
}

public class PersistenceHelper: ExternalPersistenceHelperProtocol, PersistenceHelperProtocol {
    
    internal var persistentContainer: NSPersistentContainer?
    
    var isLoaded: Bool = false
    
    var backgroundContext: NSManagedObjectContext?
    
    private static var sharedInstance: PersistenceHelper = PersistenceHelper()
    
    private init() {
        
    }
    
    public static func publicShared() -> ExternalPersistenceHelperProtocol {
        return PersistenceHelper.sharedInstance
    }
    
    internal static func shared() -> PersistenceHelperProtocol & ExternalPersistenceHelperProtocol {
        return PersistenceHelper.sharedInstance
    }
    
    public func loadPersistentStores() -> Promise<NSPersistentContainer> {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        
        guard let modelURL = Bundle.main.url(forResource: "Drive", withExtension: "momd") else {
            fatalError("Error initializing the MOM URL from the DataAccess Bundle")
        }
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        
        let promise: Promise<NSPersistentContainer> = Promise(resolver: { (resolver) in
            let container = NSPersistentContainer(name: "Drive", managedObjectModel: mom)
            container.loadPersistentStores(completionHandler: { (_, error) in
                self.isLoaded = true
                if let error = error as NSError? {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    print("Unresolved error \(error), \(error.userInfo)")
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    print("Unresolved error \(error), \(error.userInfo)")
                    resolver.reject(error)
                }
                resolver.fulfill(container)
            })
            self.persistentContainer = container
        })
        return promise
    }
    
    /// Saves any dirty entities in the current ManagedObjectContext and flushes the changes to disk.
    public func saveContext() {
        
        guard self.isLoaded else {
            print("Attemping to use the store before its loaded.")
            // assertionFailure("Attemping to use the store before its loaded.")
            return
        }
        let context = self.managedObjectContext()
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                let nserror = error as NSError
                print("♨️ Unresolved error \(nserror), \(nserror.userInfo) ♨️")
                assertionFailure("♐️ saveContext() failed.")
            }
        }
    }
    
    /// Only tear down the saved context if it has already been established, this can occur on failure to log in
    /// in which case the context has not been established yet.
    public func saveAndTearDownContext() {
        if backgroundContext != nil {
            saveContext()
            backgroundContext = nil
        }
    }
    
    /// Returns the same managedObjectContext each time, so all entities exist within a single context
    /// This method must be used if persistent objects are accessed across different threads.
    ///
    /// - Returns: the managedObjectContext
    internal func managedObjectContext() -> NSManagedObjectContext {
        
        if let context = backgroundContext {
            return context
        }
        
        guard let context = self.persistentContainer?.newBackgroundContext() else {
            fatalError("Attempted to access the persistent container before it has been loaded.")
        }
        
        backgroundContext = context
        return context
    }
}
