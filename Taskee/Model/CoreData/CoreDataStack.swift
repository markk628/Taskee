//
//  CoreDataStack.swift
//  Taskee
//
//  Created by Mark Kim on 9/22/20.
//

import Foundation
import CoreData

class CoreDataStack {
    
    private let modelName: String
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    lazy var fetchedContext: NSFetchRequest<Project> = {
        return Project.fetchRequest()
    }()
    
    lazy var mainContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()
    
    lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
}

// MARK: Internal
extension CoreDataStack {
    func saveContext() {
        guard mainContext.hasChanges else { return }
        do {
            try mainContext.save()
        } catch let nserror as NSError {
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func fetchPersistentData(completion: @escaping (FetchProjectResult) -> Void) {
//        let fetchRequest: NSFetchRequest<Project> = Project.fetchRequest()
        do {
            let allProjects = try mainContext.fetch(fetchedContext)
            completion(.succes(allProjects))
        } catch {
            completion(.failure(error))
        }
    }
}

enum FetchProjectResult {
    case succes([Project])
    case failure(Error)
}
