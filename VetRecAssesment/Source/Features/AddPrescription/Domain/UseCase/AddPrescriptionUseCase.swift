import Foundation

struct AddPrescriptionUseCase {

    private let repository: PrescriptionsRepositoryProtocol

    init(repository: PrescriptionsRepositoryProtocol = PrescriptionsRepository()) {
        self.repository = repository
    }

    func execute(prescription: Prescription, pet: Pet) throws {
        do {
            try repository.addPrescription(prescription, to: pet)
        } catch {
            throw error.asAppError
        }
    }
}
