import Foundation

protocol PrescriptionsRepositoryProtocol {
    func fetchPrescriptions(for petID: UUID) throws -> [Prescription]
    func addPrescription(_ prescription: Prescription, to pet: Pet) throws
}
