import Foundation

struct AddPetUseCase {

    private let repository: PetsRepositoryProtocol

    init(repository: PetsRepositoryProtocol = PetsRepository()) {
        self.repository = repository
    }

    func execute(pet: Pet) throws {
        do {
            try repository.addPet(pet)
        } catch {
            throw error.asAppError
        }
    }
}
