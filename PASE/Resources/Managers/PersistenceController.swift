//
//  PersistenceController.swift
//  PASE
//
//  Created by Américo MQ on 05/07/25.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "PASEModel")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { desc, error in
            if let error = error {
                fatalError("Error cargando Core Data \(error)")
            }
        }
    }
}
