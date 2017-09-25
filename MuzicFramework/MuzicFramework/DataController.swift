//
//  DataController.swift
//  Muzic
//
//  Created by Michael Ngo on 2/22/17.
//

import Foundation
import CoreData

public class DataController: NSObject {
    public var managedObjectContext: NSManagedObjectContext
    public override init() {
        guard let modelURL = Bundle.main.url(forResource: "Muzic", withExtension:"momd") else {
            fatalError("Error loading model from bundle")
        }
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = psc
        DispatchQueue.global().async() {
            let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.appdev")
            let storeURL = url?.appendingPathComponent("Muzic.sqlite")
            do {
                try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
            } catch {
                fatalError("Error migrating store: \(error)")
            }
        }
    }
    
    public func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

