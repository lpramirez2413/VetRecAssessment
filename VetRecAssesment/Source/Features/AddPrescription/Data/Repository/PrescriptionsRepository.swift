import Foundation

class PrescriptionsRepository: PrescriptionsRepositoryProtocol {

    private let local: PrescriptionsLocalDataSource

    convenience init(persistenceController: PersistenceController = .shared) {
        let context = persistenceController.newBackgroundContext()
        self.init(local: PrescriptionsLocalDataSource(context: context))
    }

    init(local: PrescriptionsLocalDataSource) {
        self.local = local
    }

    func fetchPrescriptions(for petID: UUID) throws -> [Prescription] {
        try local.fetchPrescriptions(for: petID)
    }

    func addPrescription(_ prescription: Prescription, to pet: Pet) throws {
        try local.addPrescription(prescription, to: pet)
    }
}
