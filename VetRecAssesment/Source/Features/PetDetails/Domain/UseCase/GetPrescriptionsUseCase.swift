import Foundation

struct GetPrescriptionsUseCase {

    private let repository: PrescriptionsRepositoryProtocol

    init(repository: PrescriptionsRepositoryProtocol = PrescriptionsRepository()) {
        self.repository = repository
    }

    func execute(petID: UUID) throws -> [Prescription] {
        do {
            return try repository.fetchPrescriptions(for: petID)
        } catch {
            throw error.asAppError
        }
    }
}
