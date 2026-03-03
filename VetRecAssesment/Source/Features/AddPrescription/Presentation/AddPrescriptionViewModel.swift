import SwiftUI

enum AddPrescriptionMode {
    case add
    case readOnly(Prescription)
}

@MainActor
class AddPrescriptionViewModel: ObservableObject {

    let mode: AddPrescriptionMode
    let pet: Pet

    // Form fields
    @Published var title: String = ""
    @Published var medicationName: String = ""
    @Published var dosage: String = ""
    @Published var dosageUnit: String = "mg"
    @Published var frequencyValue: Int = 1
    @Published var frequencyUnit: TimeUnit = .hours
    @Published var notes: String = ""
    @Published var startDate: Date = Date()
    @Published var durationValue: Int = 7
    @Published var durationUnit: DurationUnit = .days
    @Published var selectedPhoto: UIImage?

    @Published var errorMessage: String?
    @Published var pdfURL: URL?

    static let dosageUnits = ["mg", "ml", "tablets", "drops"]

    var isReadOnly: Bool {
        if case .readOnly = mode { return true }
        return false
    }

    var isSaveEnabled: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty &&
        !medicationName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !dosage.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var endDate: Date {
        startDate.adding(durationValue, unit: durationUnit)
    }

    private let addPrescriptionUseCase: AddPrescriptionUseCase

    init(mode: AddPrescriptionMode,
         pet: Pet,
         addPrescriptionUseCase: AddPrescriptionUseCase = AddPrescriptionUseCase()) {
        self.mode = mode
        self.pet = pet
        self.addPrescriptionUseCase = addPrescriptionUseCase

        if case .readOnly(let prescription) = mode {
            self.title = prescription.title
            self.medicationName = prescription.medicationName
            self.dosage = prescription.dosage
            self.dosageUnit = prescription.dosageUnit
            self.frequencyValue = prescription.frequencyValue
            self.frequencyUnit = prescription.frequencyUnit
            self.notes = prescription.notes
            self.startDate = prescription.startDate
            self.durationValue = prescription.durationValue
            self.durationUnit = prescription.durationUnit
            if let path = prescription.photoPath {
                self.selectedPhoto = UIImage(contentsOfFile: path)
            }
        }
    }

    func save(onSuccess: () -> Void) {
        let prescription = Prescription(
            id: UUID(),
            medicationName: medicationName.trimmingCharacters(in: .whitespaces),
            dosage: dosage,
            dosageUnit: dosageUnit,
            frequencyValue: frequencyValue,
            frequencyUnit: frequencyUnit,
            title: title.trimmingCharacters(in: .whitespaces),
            notes: notes,
            startDate: startDate,
            durationValue: durationValue,
            durationUnit: durationUnit,
            photoPath: selectedPhoto.flatMap { savePhotoToDocuments($0) },
            createdAt: Date()
        )

        do {
            try addPrescriptionUseCase.execute(prescription: prescription, pet: pet)
            onSuccess()
        } catch let error as AppError {
            errorMessage = error.message
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func preparePDF() {
        let prescription: Prescription

        if case .readOnly(let rx) = mode {
            prescription = rx
        } else {
            prescription = Prescription(
                id: UUID(),
                medicationName: medicationName,
                dosage: dosage,
                dosageUnit: dosageUnit,
                frequencyValue: frequencyValue,
                frequencyUnit: frequencyUnit,
                title: title.isEmpty ? "Prescription" : title,
                notes: notes,
                startDate: startDate,
                durationValue: durationValue,
                durationUnit: durationUnit,
                photoPath: nil,
                createdAt: Date()
            )
        }

        let pdfData = PDFGenerator.generate(
            petName: pet.name,
            clientName: pet.clientName,
            prescription: prescription
        )

        let fileName = "\(pet.name)_\(prescription.title)"
            .replacingOccurrences(of: " ", with: "_") + ".pdf"
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        try? pdfData.write(to: url)
        self.pdfURL = url
    }

    private func savePhotoToDocuments(_ image: UIImage) -> String? {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(UUID().uuidString + ".jpg")
        try? data.write(to: url)
        return url.path
    }
}
