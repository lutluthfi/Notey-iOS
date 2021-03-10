//
//  CoreDataStorage.swift
//  Writey
//
//  Created by Arif Luthfiansyah on 21/02/21.
//

import CoreData
import Foundation

public typealias CoreID = NSManagedObjectID

public enum CoreDataStorageError: LocalizedError {
    case readError(Error)
    case saveError(Error)
    case deleteError(Error)
}

extension CoreDataStorageError {
    
    public var errorDescription: String? {
        switch self {
        case .deleteError(let error):
            return error.localizedDescription
        case .readError(let error):
            return error.localizedDescription
        case .saveError(let error):
            return error.localizedDescription
        }
    }
    
}

public protocol CoreDataStorageShared {
    
    var fetchContainerName: String { get }
    
    var fetchCollectionTimeout: TimeInterval { get }
    
    var fetchElementTimeout: TimeInterval { get }
    
    var insertCollectionTimeout: TimeInterval { get }
    
    var insertElementTimeout: TimeInterval { get }
    
    var removeCollectionTimeout: TimeInterval { get }
    
    var removeElementTimeout: TimeInterval { get }
    
    func saveContext()
    
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void)
    
}

public final class CoreDataStorage {
    
    public static let shared: CoreDataStorageShared = CoreDataStorage()
    
    private init() { }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.fetchContainerName)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                debugPrint("CoreDataStorage Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
}

extension CoreDataStorage: CoreDataStorageShared {
    
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
        let context = self.persistentContainer.viewContext
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            debugPrint("CoreDataStorage Unresolved error \(error), \((error as NSError).userInfo)")
        }
    }
    
    public func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        self.persistentContainer.performBackgroundTask(block)
    }
    
}
