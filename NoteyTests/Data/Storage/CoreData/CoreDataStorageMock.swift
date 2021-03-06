//
//  CoreDataStorageMock.swift
//  NoteyTests
//
//  Created by Arif Luthfiansyah on 28/02/21.
//

import CoreData
import XCTest
@testable import Notey

class CoreDataStorageMock {

    lazy var managedObjectModel: NSManagedObjectModel = {
        let bundles = [Bundle(for: type(of: self))]
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: bundles)!
        return managedObjectModel
    }()
    lazy var persistantContainerMock: NSPersistentContainer = {
        let container = NSPersistentContainer(name: CoreDataStorage.shared.fetchContainerName,
                                              managedObjectModel: self.managedObjectModel)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            // Check if the data store is in memory
            precondition(description.type == NSInMemoryStoreType)
            // Check if creating container wrong
            if let error = error {
                fatalError("Create an in-mem coordinator failed \(error)")
            }
        }
        return container
    }()
    
    func performBackground(_ block: @escaping (NSManagedObjectContext) -> Void) {
        self.persistantContainerMock.performBackgroundTask(block)
    }

}

protocol CoreDataStorageSharedMock: CoreDataStorageShared {
    
    var context: NSManagedObjectContext { get }
    
}

extension CoreDataStorageMock: CoreDataStorageSharedMock {
    
    public var context: NSManagedObjectContext {
        return self.persistantContainerMock.viewContext
    }
    
    public var fetchContainerName: String {
        return "CoreDataStorage"
    }
    
    public var fetchCollectionTimeout: TimeInterval {
        return TimeInterval(60)
    }
    
    public var fetchElementTimeout: TimeInterval {
        return TimeInterval(30)
    }
    
    public var insertCollectionTimeout: TimeInterval {
        return TimeInterval(60)
    }
    
    public var insertElementTimeout: TimeInterval {
        return TimeInterval(30)
    }
    
    public var removeCollectionTimeout: TimeInterval {
        return TimeInterval(60)
    }
    
    public var removeElementTimeout: TimeInterval {
        return TimeInterval(30)
    }
    
    public func saveContext() {
        let context = self.persistantContainerMock.viewContext
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            debugPrint("CoreDataStorage Unresolved error \(error), \((error as NSError).userInfo)")
        }
    }
    
    public func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        self.persistantContainerMock.performBackgroundTask(block)
    }
    
}
