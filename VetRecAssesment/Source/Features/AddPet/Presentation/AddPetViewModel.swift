import SwiftUI

@MainActor
class AddPetViewModel: ObservableObject {

    @Published var name: String = ""
    @Published var species: Species = .dog
    @Published var clientName: String = ""
    @Published var imageURL: String = ""
    @Published var isFetchingImage: Bool = false
    @Published var errorMessage: String?

    var isSaveEnabled: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        !clientName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !imageURL.isEmpty
    }

    private let addPetUseCase: AddPetUseCase

    init(addPetUseCase: AddPetUseCase = AddPetUseCase()) {
        self.addPetUseCase = addPetUseCase
    }

    func fetchImage() async {
        isFetchingImage = true
        defer { isFetchingImage = false }
        imageURL = ""

        guard let url = URL(string: "https://animals.maxz.dev/api/\(species.rawValue)") else { return }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(AnimalImageResponse.self, from: data)
            imageURL = response.image
        } catch {
            errorMessage = "Could not load image"
        }
    }

    func save(onSuccess: () -> Void) {
        let pet = Pet(
            id: UUID(),
            name: name.trimmingCharacters(in: .whitespaces),
            species: species,
            clientName: clientName.trimmingCharacters(in: .whitespaces),
            imageURL: imageURL,
            prescriptions: []
        )
        do {
            try addPetUseCase.execute(pet: pet)
            onSuccess()
        } catch let error as AppError {
            errorMessage = error.message
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

private struct AnimalImageResponse: Decodable {
    let image: String
}
