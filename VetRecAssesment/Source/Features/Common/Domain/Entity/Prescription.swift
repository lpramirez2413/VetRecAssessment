import Foundation

struct Prescription: Identifiable, Equatable, Hashable {
    let id: UUID
    let medicationName: String
    let dosage: String
    let dosageUnit: String
    let frequencyValue: Int
    let frequencyUnit: TimeUnit
    let title: String
    let notes: String
    let startDate: Date
    let durationValue: Int
    let durationUnit: DurationUnit
    let photoPath: String?
    let createdAt: Date

    var endDate: Date {
        startDate.adding(durationValue, unit: durationUnit)
    }

    var frequencyDescription: String {
        "Every \(frequencyValue) \(frequencyUnit.rawValue)"
    }

    var durationDescription: String {
        "\(durationValue) \(durationUnit.rawValue)"
    }
}
