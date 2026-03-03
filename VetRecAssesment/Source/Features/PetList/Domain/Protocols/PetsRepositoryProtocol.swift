import Foundation

protocol PetsRepositoryProtocol {
    func fetchPets() async throws -> [Pet]
    func addPet(_ pet: Pet) throws
}
