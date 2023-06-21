//
//  StorageService.swift
//  SimpleApp
//
//  Created by Юрий Альт on 22.06.2023.
//

import CoreData

class StorageService {

    static let shared = StorageService()

    // MARK: Core Data stack
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SavedMedia")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    private let viewContext: NSManagedObjectContext
    private init() {
        viewContext = persistentContainer.viewContext
    }

    func fetchData(completion: (Result<[SavedMedia], Error>) -> Void) {
        let fetchRequest: NSFetchRequest<SavedMedia> = SavedMedia.fetchRequest()
        do {
            let addedTags = try viewContext.fetch(fetchRequest)
            completion(.success(addedTags))
        } catch let error {
            completion(.failure(error))
        }
    }

    //MARK: Save and delete Data
    func save(artistName: String, trackName: String, artworkUrl100: Data) {
        let savedMedia = SavedMedia(context: viewContext)
        savedMedia.artistName = artistName
        savedMedia.trackName = trackName
        savedMedia.artworkUrl100 = artworkUrl100
        saveContext()
    }
    
    func delete(_ item: SavedMedia) {
        viewContext.delete(item)
        saveContext()
    }
    
    func clearDataBase() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "SavedMedia")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try viewContext.execute(batchDeleteRequest)
            saveContext()
        } catch {
            print("Error clearing data: \(error)")
        }
    }

    // MARK: CoreData saving support
    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
