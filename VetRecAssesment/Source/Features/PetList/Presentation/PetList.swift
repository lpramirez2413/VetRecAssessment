import SwiftUI

struct PetList: View {

    @StateObject private var viewModel = PetListViewModel()
    @State private var showAddPet = false

    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.viewState {
                case .loading:
                    ProgressView()
                case .loaded, .idle:
                    petList
                case .error(let error):
                    buildErrorView(message: error.message)
                }
            }
            .navigationTitle("Pets")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showAddPet = true } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddPet) {
                AddPetView {
                    viewModel.fetchPets()
                }
            }
            .onAppear {
                viewModel.fetchPets()
            }
        }
    }

    private var petList: some View {
        List(viewModel.pets) { pet in
            NavigationLink(value: pet) {
                PetRow(pet: pet)
            }
        }
        .listStyle(.insetGrouped)
        .navigationDestination(for: Pet.self) { pet in
            // PetDetailsView — coming in the next step
            Text("\(pet.name)'s details — coming soon")
                .navigationTitle(pet.name)
        }
    }
    
    private func buildErrorView(message: String) -> some View {
        Text(message)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
            .padding()
    }
}
