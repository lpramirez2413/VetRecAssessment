import SwiftUI

@MainActor
class PetListViewModel: ObservableObject {

    @Published var pets: [Pet] = []
    @Published var viewState: ViewState = .loading

    private let getPetsUseCase: GetPetsUseCase

    init(getPetsUseCase: GetPetsUseCase = GetPetsUseCase()) {
        self.getPetsUseCase = getPetsUseCase
    }

    func fetchPets() {
        viewState = .loading
        Task {
            do {
                pets = try await getPetsUseCase.execute()
                viewState = .loaded
            } catch let error as AppError {
                viewState = .error(error)
            } catch {
                viewState = .error(.unknown(error.localizedDescription))
            }
        }
    }
}
