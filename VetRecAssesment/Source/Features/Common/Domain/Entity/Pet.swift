import Foundation

struct Pet: Identifiable, Equatable, Hashable {
    let id: UUID
    let name: String
    let species: Species
    let clientName: String
    let imageURL: String
    var prescriptions: [Prescription]
}
