import SwiftUI

@MainActor
class PetDetailsViewModel: ObservableObject {

    @Published var prescriptions: [Prescription] = []

    let pet: Pet
    private let getPrescriptionsUseCase: GetPrescriptionsUseCase

    init(pet: Pet, getPrescriptionsUseCase: GetPrescriptionsUseCase = GetPrescriptionsUseCase()) {
        self.pet = pet
        self.getPrescriptionsUseCase = getPrescriptionsUseCase
    }

    func loadPrescriptions() {
        do {
            prescriptions = try getPrescriptionsUseCase.execute(petID: pet.id)
        } catch {
            prescriptions = []
        }
    }
}
