import CoreData

class PrescriptionsLocalDataSource {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetchPrescriptions(for petID: UUID) throws -> [Prescription] {
        try context.performAndWait {
            let request: NSFetchRequest<PetEntity> = PetEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", petID as CVarArg)
            guard let petEntity = try context.fetch(request).first else { return [] }
            return (petEntity.prescriptions as? Set<PrescriptionEntity> ?? [])
                .sorted { ($0.startDate ?? Date()) > ($1.startDate ?? Date()) }
                .map { PetMapper.toPrescription(from: $0) }
        }
    }

    func addPrescription(_ prescription: Prescription, to pet: Pet) throws {
        try context.performAndWait {
            let request: NSFetchRequest<PetEntity> = PetEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", pet.id as CVarArg)

            guard let petEntity = try context.fetch(request).first else {
                throw AppError.persistenceFailed
            }

            let entity = PrescriptionEntity(context: context)
            entity.id = prescription.id
            entity.medicationName = prescription.medicationName
            entity.dosage = prescription.dosage
            entity.dosageUnit = prescription.dosageUnit
            entity.frequencyValue = Int16(prescription.frequencyValue)
            entity.frequencyUnit = prescription.frequencyUnit.rawValue
            entity.title = prescription.title
            entity.notes = prescription.notes
            entity.startDate = prescription.startDate
            entity.durationValue = Int16(prescription.durationValue)
            entity.durationUnit = prescription.durationUnit.rawValue
            entity.photoPath = prescription.photoPath
            entity.createdAt = prescription.createdAt
            entity.pet = petEntity

            try context.save()
        }
    }
}
