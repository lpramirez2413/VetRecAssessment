import Foundation

protocol PetsRemoteDataSourceProtocol {
    func fetchPets() async throws -> [PetModel]
}
