//
//  FavoritesRepositoryCoreData.swift
//  PASE
//
//  Created by Américo MQ on 05/07/25.
//

import CoreData

class FavoritesRepositoryCoreData: FavoritesRepository {
    private let container: NSPersistentContainer

    init(container: NSPersistentContainer = PersistenceController.shared.container) {
        self.container = container
    }

    func isFavorite(characterId: Int) -> Bool {
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<FavoriteCharacter> = FavoriteCharacter.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", characterId)

        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Error checking favorite status: \(error)")
            return false
        }
    }

    func addFavorite(character: Character) async throws {
        let context = container.viewContext
        let favorite = FavoriteCharacter(context: context)
        favorite.id = Int64(character.id)
        favorite.name = character.name
        favorite.image = character.image

        try context.save()
    }

    func removeFavorite(characterId: Int) async throws {
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<FavoriteCharacter> = FavoriteCharacter.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", characterId)

        if let results = try? context.fetch(fetchRequest) {
            for object in results {
                context.delete(object)
            }
            try context.save()
        }
    }

    func fetchAllFavorites() async throws -> [Character] {
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<FavoriteCharacter> = FavoriteCharacter.fetchRequest()

        let results = try context.fetch(fetchRequest)
        
        return results.compactMap { favorite in
            Character(
                id: Int(favorite.id),
                name: favorite.name ?? "",
                status: "", species: "", type: "", gender: "",
                image: favorite.image ?? "",
                url: "",
                created: "",
                origin: Location(name: "", url: ""),
                location: Location(name: "", url: ""),
                episode: []
            )
        }
    }
}


