import Foundation

struct GetPrescriptionsUseCase {

    func execute(for pet: Pet) -> [Prescription] {
        pet.prescriptions.sorted { $0.startDate > $1.startDate }
    }
}
