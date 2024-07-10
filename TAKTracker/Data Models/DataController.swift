//
//  DataController.swift
//  TAKTracker
//
//  Created by Cory Foy on 7/6/24.
//

import CoreData
import Foundation

class DataController: ObservableObject {
    
    static let shared = DataController()
    
    let cotDataContainer = NSPersistentContainer(name: "COTData")
    var managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    var cleanUpTimer: Timer?
    
    private init() {
        cotDataContainer.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        cotDataContainer.viewContext.automaticallyMergesChangesFromParent = true
        cotDataContainer.loadPersistentStores { description, error in
            if let error = error {
                TAKLogger.error("[DataController] Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
    
    func startCleanUpTimer() {
        guard cleanUpTimer == nil else { return }
        cleanUpTimer = Timer.scheduledTimer(withTimeInterval: 15.0, repeats: true) { _ in
            self.cotDataContainer.performBackgroundTask { dataContext in
                let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "COTData")
                let predicate = NSPredicate(format: "staleDate < %@", Date() as CVarArg)
                fetch.predicate = predicate
                let request = NSBatchDeleteRequest(fetchRequest: fetch)

                do {
                    print("Cleaning Stales...")
                    try dataContext.execute(request)
                } catch {
                    TAKLogger.error("[DataController] Unable to clear stales \(error)")
                }
            }
        }
    }
}
