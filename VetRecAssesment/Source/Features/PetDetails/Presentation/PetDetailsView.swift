import SwiftUI

struct PetDetailsView: View {

    @StateObject private var viewModel: PetDetailsViewModel
    @State private var showAddPrescription = false
    @State private var selectedPrescription: Prescription?

    init(pet: Pet) {
        _viewModel = StateObject(wrappedValue: PetDetailsViewModel(pet: pet))
    }

    var body: some View {
        List {
            headerSection
            prescriptionsSection
        }
        .listStyle(.insetGrouped)
        .navigationTitle(viewModel.pet.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button { showAddPrescription = true } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showAddPrescription, onDismiss: viewModel.loadPrescriptions) {
            AddPrescriptionView(mode: .add, pet: viewModel.pet) {
                viewModel.loadPrescriptions()
            }
        }
        .sheet(item: $selectedPrescription) { prescription in
            AddPrescriptionView(mode: .readOnly(prescription), pet: viewModel.pet)
        }
        .onAppear {
            viewModel.loadPrescriptions()
        }
    }

    // MARK: Header Section
    private var headerSection: some View {
        Section {
            HStack(spacing: Spacing.m) {
                CachedImageView(urlString: viewModel.pet.imageURL, size: Sizing.xxl)

                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text(viewModel.pet.name)
                        .font(.title3)
                        .fontWeight(.semibold)
                    Text(viewModel.pet.species.displayName)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    HStack {
                        Spacer()
                        Image(systemName: "person.fill")
                            .resizable()
                            .frame(width: 10, height: 10)
                        Text(viewModel.pet.clientName)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                }
            }
            .padding(.vertical, Spacing.xs)
        }
    }

    // MARK: Prescriptions Section
    private var prescriptionsSection: some View {
        Section("Prescriptions") {
            if viewModel.prescriptions.isEmpty {
                Text("No prescriptions yet")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(viewModel.prescriptions) { prescription in
                    Button {
                        selectedPrescription = prescription
                    } label: {
                        PrescriptionRow(prescription: prescription)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}
