//
//  PersistanceHelper.swift
//  ListingsApp
//
//  Created by Christie Davis on 6/08/19.
//  Copyright © 2019 Christie-Davis. All rights reserved.
//

import UIKit
import CoreData
import PromiseKit

 protocol PersistenceHelperProtocol: class {
    func saveContext()
    func loadPersistentStores() -> Promise<NSPersistentContainer>
    static func shared() -> PersistenceHelperProtocol
    func managedObjectContext() -> NSManagedObjectContext 
}

public class PersistenceHelper: PersistenceHelperProtocol {
    
    internal var persistentContainer: NSPersistentContainer?
    
    var isLoaded: Bool = false
    
    var backgroundContext: NSManagedObjectContext?
    
    private static var sharedInstance: PersistenceHelper = PersistenceHelper()
    
    private init() {
        
    }
    
    internal static func shared() -> PersistenceHelperProtocol {
        return PersistenceHelper.sharedInstance
    }
    
    public func loadPersistentStores() -> Promise<NSPersistentContainer> {
        
        guard let modelURL = Bundle.main.url(forResource: "ListingsApp", withExtension: "momd") else {
            fatalError("Error initializing the MOM URL from the Bundle")
        }
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        
        let promise: Promise<NSPersistentContainer> = Promise(resolver: { (resolver) in
            let container = NSPersistentContainer(name: "Drive", managedObjectModel: mom)
            container.loadPersistentStores(completionHandler: { (_, error) in
                self.isLoaded = true
                if let error = error as NSError? {
                    print("Unresolved error \(error), \(error.userInfo)")
                    resolver.reject(error)
                }
                resolver.fulfill(container)
            })
            self.persistentContainer = container
        })
        return promise
    }
    
    public func saveContext() {
        
        guard self.isLoaded else {
            return
        }
        let context = self.managedObjectContext()
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                let nserror = error as NSError
//                Logger.error("♨️ Unresolved error \(nserror), \(nserror.userInfo) ♨️", forSubsystem: .services)
                assertionFailure("♐️ saveContext() failed.")
            }
        }
    }
    
    public func saveAndTearDownContext() {
        if backgroundContext != nil {
            saveContext()
            backgroundContext = nil
        }
    }
    
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
