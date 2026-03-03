import Foundation

protocol PrescriptionsRepositoryProtocol {
    func addPrescription(_ prescription: Prescription, to pet: Pet) throws
}
