import Foundation

struct PrescriptionModel: Codable {
    let id: String
    let medicationName: String
    let dosage: String
    let dosageUnit: String
    let frequencyValue: Int
    let frequencyUnit: String
    let title: String
    let notes: String
    let startDate: String
    let durationValue: Int
    let durationUnit: String
}
