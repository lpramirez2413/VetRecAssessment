import Foundation

protocol PetsLocalDataSourceProtocol {
    func fetchPets() throws -> [PetEntity]
    func savePets(from models: [PetModel]) throws
    func addPet(_ pet: Pet) throws
}
