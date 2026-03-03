import Foundation

struct GetPetsUseCase {

    private let repository: PetsRepositoryProtocol

    init(repository: PetsRepositoryProtocol = PetsRepository()) {
        self.repository = repository
    }

    func execute() async throws -> [Pet] {
        do {
            return try await repository.fetchPets()
        } catch {
            throw error.asAppError
        }
    }
}
