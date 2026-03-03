import Foundation

struct PetModel: Codable {
    let id: String
    let name: String
    let species: String
    let clientName: String
    let imageURL: String
    let prescriptions: [PrescriptionModel]
}
