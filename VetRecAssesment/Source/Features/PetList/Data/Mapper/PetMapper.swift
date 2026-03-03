import Foundation

struct PetMapper {

    static func toPet(from model: PetModel) -> Pet {
        Pet(
            id: UUID(uuidString: model.id) ?? UUID(),
            name: model.name,
            species: Species(rawValue: model.species) ?? .dog,
            clientName: model.clientName,
            imageURL: model.imageURL,
            prescriptions: model.prescriptions.map { toPrescription(from: $0) }
        )
    }

    static func toPet(from entity: PetEntity) -> Pet {
        let prescriptions = (entity.prescriptions as? Set<PrescriptionEntity> ?? [])
            .sorted { ($0.startDate ?? Date()) > ($1.startDate ?? Date()) }
            .map { toPrescription(from: $0) }

        return Pet(
            id: entity.id ?? UUID(),
            name: entity.name ?? "",
            species: Species(rawValue: entity.species ?? "") ?? .dog,
            clientName: entity.clientName ?? "",
            imageURL: entity.imageURL ?? "",
            prescriptions: prescriptions
        )
    }

    // MARK: - Internal helpers

    static func toPrescription(from model: PrescriptionModel) -> Prescription {
        Prescription(
            id: UUID(uuidString: model.id) ?? UUID(),
            medicationName: model.medicationName,
            dosage: model.dosage,
            dosageUnit: model.dosageUnit,
            frequencyValue: model.frequencyValue,
            frequencyUnit: TimeUnit(rawValue: model.frequencyUnit) ?? .hours,
            title: model.title,
            notes: model.notes,
            startDate: Date.from(iso8601: model.startDate) ?? Date(),
            durationValue: model.durationValue,
            durationUnit: DurationUnit(rawValue: model.durationUnit) ?? .days,
            photoPath: nil,
            createdAt: Date()
        )
    }

    static func toPrescription(from entity: PrescriptionEntity) -> Prescription {
        Prescription(
            id: entity.id ?? UUID(),
            medicationName: entity.medicationName ?? "",
            dosage: entity.dosage ?? "",
            dosageUnit: entity.dosageUnit ?? "",
            frequencyValue: Int(entity.frequencyValue),
            frequencyUnit: TimeUnit(rawValue: entity.frequencyUnit ?? "") ?? .hours,
            title: entity.title ?? "",
            notes: entity.notes ?? "",
            startDate: entity.startDate ?? Date(),
            durationValue: Int(entity.durationValue),
            durationUnit: DurationUnit(rawValue: entity.durationUnit ?? "") ?? .days,
            photoPath: entity.photoPath,
            createdAt: entity.createdAt ?? Date()
        )
    }
}
