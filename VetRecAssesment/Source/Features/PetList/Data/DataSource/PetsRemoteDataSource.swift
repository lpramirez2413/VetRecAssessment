import Foundation

struct PetsRemoteDataSource: PetsRemoteDataSourceProtocol {

    func fetchPets() async throws -> [PetModel] {
        try await Task.sleep(for: .milliseconds(500))

        guard let url = Bundle.main.url(forResource: "pets", withExtension: "json") else {
            throw AppError.fileNotFound
        }

        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode([PetModel].self, from: data)
        } catch is DecodingError {
            throw AppError.decodingFailed
        }
    }
}
