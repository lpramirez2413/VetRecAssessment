import CoreData

class PetsLocalDataSource: PetsLocalDataSourceProtocol {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetchPets() throws -> [PetEntity] {
        try context.performAndWait {
            let request: NSFetchRequest<PetEntity> = PetEntity.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
            return try context.fetch(request)
        }
    }

    func savePets(from models: [PetModel]) throws {
        try context.performAndWait {
            for model in models {
                let pet = PetEntity(context: context)
                pet.id = UUID(uuidString: model.id)
                pet.name = model.name
                pet.species = model.species
                pet.clientName = model.clientName
                pet.imageURL = model.imageURL

                for prescription in model.prescriptions {
                    let entity = PrescriptionEntity(context: context)
                    entity.id = UUID(uuidString: prescription.id)
                    entity.medicationName = prescription.medicationName
                    entity.dosage = prescription.dosage
                    entity.dosageUnit = prescription.dosageUnit
                    entity.frequencyValue = Int16(prescription.frequencyValue)
                    entity.frequencyUnit = prescription.frequencyUnit
                    entity.title = prescription.title
                    entity.notes = prescription.notes
                    entity.startDate = Date.from(iso8601: prescription.startDate)
                    entity.durationValue = Int16(prescription.durationValue)
                    entity.durationUnit = prescription.durationUnit
                    entity.createdAt = Date()
                    entity.pet = pet
                }
            }
            try context.save()
        }
    }

    func addPet(_ pet: Pet) throws {
        try context.performAndWait {
            let entity = PetEntity(context: context)
            entity.id = pet.id
            entity.name = pet.name
            entity.species = pet.species.rawValue
            entity.clientName = pet.clientName
            entity.imageURL = pet.imageURL
            try context.save()
        }
    }
}
