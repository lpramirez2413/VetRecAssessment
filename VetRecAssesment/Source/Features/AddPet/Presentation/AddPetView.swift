import SwiftUI

struct AddPetView: View {

    @StateObject private var viewModel = AddPetViewModel()
    @Environment(\.dismiss) private var dismiss

    var onSave: () -> Void

    var body: some View {
        NavigationStack {
            List {
                nameSection
                speciesSection
                clientSection
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Add Pet")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.primary)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        viewModel.save {
                            onSave()
                            dismiss()
                        }
                    }
                    .fontWeight(.semibold)
                    .disabled(!viewModel.isSaveEnabled)
                }
            }
            .task {
                await viewModel.fetchImage()
            }
            .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("OK") { viewModel.errorMessage = nil }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
    }

    // MARK: Name Section
    private var nameSection: some View {
        Section("Name") {
            TextField("e.g. Chorizo", text: $viewModel.name)
        }
    }

    // MARK: Species Section
    private var speciesSection: some View {
        Section("Species") {
            HStack {
                Picker(selection: $viewModel.species, label: EmptyView()) {
                    ForEach(Species.allCases) { species in
                        Text(species.displayName).tag(species)
                    }
                }
                .pickerStyle(.menu)
                .labelsHidden()
                .onChange(of: viewModel.species) {
                    Task { await viewModel.fetchImage() }
                }

                Spacer()

                imagePreview
            }
            .padding(.vertical, Spacing.xs)
        }
    }

    // MARK: Client name Section
    private var clientSection: some View {
        Section("Client Name") {
            TextField("e.g. Luis Perez", text: $viewModel.clientName)
        }
    }

    @ViewBuilder
    private var imagePreview: some View {
        if viewModel.isFetchingImage {
            ProgressView()
                .frame(width: Sizing.xxl, height: Sizing.xxl)
        } else if !viewModel.imageURL.isEmpty {
            CachedImageView(urlString: viewModel.imageURL, size: Sizing.xxl)
        } else {
            Image(systemName: "pawprint.fill")
                .resizable()
                .scaledToFit()
                .frame(width: Sizing.xxl, height: Sizing.xxl)
                .foregroundStyle(.secondary)
        }
    }
}
