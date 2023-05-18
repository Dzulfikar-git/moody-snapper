//
//  PersistenceController.swift
//  MoodySnapper
//
//  Created by Dzulfikar on 14/05/23.
//
// This controller will be used to load and manage Core Data configuration

import Foundation
import CoreData

struct DailySnapsPersistenceController {
    static let shared = DailySnapsPersistenceController()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        // If you didn't name your model Main you'll need
        // to change this name below.
        container = NSPersistentContainer(name: "DailySnaps")

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
}

