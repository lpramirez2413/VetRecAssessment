import Foundation

class PetsRepository: PetsRepositoryProtocol {

    private let remote: PetsRemoteDataSourceProtocol
    private let local: PetsLocalDataSourceProtocol
    private let storage: LocalStorage

    convenience init(persistenceController: PersistenceController = .shared) {
        let context = persistenceController.newBackgroundContext()
        self.init(
            remote: PetsRemoteDataSource(),
            local: PetsLocalDataSource(context: context),
            storage: .shared
        )
    }

    init(remote: PetsRemoteDataSourceProtocol,
         local: PetsLocalDataSourceProtocol,
         storage: LocalStorage = .shared) {
        self.remote = remote
        self.local = local
        self.storage = storage
    }

    func fetchPets() async throws -> [Pet] {
        if storage.isFirstLaunch {
            let models = try await remote.fetchPets()
            try local.savePets(from: models)
            storage.isFirstLaunch = false
        }
        return try local.fetchPets().map { PetMapper.toPet(from: $0) }
    }

    func addPet(_ pet: Pet) throws {
        try local.addPet(pet)
    }
}
