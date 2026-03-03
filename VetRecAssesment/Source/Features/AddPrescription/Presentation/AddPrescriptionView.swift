import SwiftUI
import PhotosUI

struct AddPrescriptionView: View {

    // Private properties
    @StateObject private var viewModel: AddPrescriptionViewModel
    @State private var selectedItem: PhotosPickerItem?
    @State private var isSharing = false
    @Environment(\.dismiss) private var dismiss

    // Public properties
    var onSave: () -> Void

    init(mode: AddPrescriptionMode, pet: Pet, onSave: @escaping () -> Void = {}) {
        _viewModel = StateObject(
            wrappedValue: AddPrescriptionViewModel(
                mode: mode,
                pet: pet
            )
        )
        self.onSave = onSave
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Spacing.m) {
                    formFields
                    shareButton
                }
                .padding(.vertical, Spacing.m)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(viewModel.isReadOnly ? "Prescription" : "Add Prescription")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark").foregroundStyle(.primary)
                    }
                }
                if !viewModel.isReadOnly {
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
            }
            .sheet(isPresented: $isSharing) {
                if let url = viewModel.pdfURL {
                    ShareSheet(items: [url])
                }
            }
            .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("OK") { viewModel.errorMessage = nil }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
    }

    // MARK: - Form

    private var formFields: some View {
        VStack(spacing: Spacing.s) {

            // Title
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text("Title").font(.caption).foregroundStyle(.secondary)
                TextField("e.g. Respiratory Infection Treatment", text: $viewModel.title)
                    .disabled(viewModel.isReadOnly)
            }
            .rowCard()

            // Medication Name
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text("Medication Name").font(.caption).foregroundStyle(.secondary)
                TextField("e.g. Amoxicillin", text: $viewModel.medicationName)
                    .disabled(viewModel.isReadOnly)
            }
            .rowCard()

            // Dosage
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text("Dosage").font(.caption).foregroundStyle(.secondary)
                HStack {
                    TextField("0", text: $viewModel.dosage)
                        .keyboardType(.decimalPad)
                        .disabled(viewModel.isReadOnly)
                    Picker(selection: $viewModel.dosageUnit, label: EmptyView()) {
                        ForEach(AddPrescriptionViewModel.dosageUnits, id: \.self) { Text($0).tag($0) }
                    }
                    .pickerStyle(.menu)
                    .labelsHidden()
                    .disabled(viewModel.isReadOnly)
                }
            }
            .rowCard()

            // Frequency
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text("Frequency").font(.caption).foregroundStyle(.secondary)
                HStack {
                    Text("Every").foregroundStyle(.secondary)
                    Picker(selection: $viewModel.frequencyValue, label: EmptyView()) {
                        ForEach(1...30, id: \.self) { Text("\($0)").tag($0) }
                    }
                    .pickerStyle(.menu)
                    .labelsHidden()
                    .disabled(viewModel.isReadOnly)
                    Picker(selection: $viewModel.frequencyUnit, label: EmptyView()) {
                        ForEach(TimeUnit.allCases) { Text($0.rawValue).tag($0) }
                    }
                    .pickerStyle(.menu)
                    .labelsHidden()
                    .disabled(viewModel.isReadOnly)
                }
            }
            .rowCard()

            // Notes & Instructions
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text("Notes & Instructions").font(.caption).foregroundStyle(.secondary)
                TextEditor(text: $viewModel.notes)
                    .frame(minHeight: 80)
                    .disabled(viewModel.isReadOnly)
            }
            .rowCard()

            // Start Date
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text("Start Date").font(.caption).foregroundStyle(.secondary)
                DatePicker(selection: $viewModel.startDate, displayedComponents: .date) { EmptyView() }
                    .labelsHidden()
                    .disabled(viewModel.isReadOnly)
            }
            .rowCard()

            // Duration
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text("Duration").font(.caption).foregroundStyle(.secondary)
                HStack {
                    Picker(selection: $viewModel.durationValue, label: EmptyView()) {
                        ForEach(1...30, id: \.self) { Text("\($0)").tag($0) }
                    }
                    .pickerStyle(.menu)
                    .labelsHidden()
                    .disabled(viewModel.isReadOnly)
                    Picker(selection: $viewModel.durationUnit, label: EmptyView()) {
                        ForEach(DurationUnit.allCases) { Text($0.rawValue).tag($0) }
                    }
                    .pickerStyle(.menu)
                    .labelsHidden()
                    .disabled(viewModel.isReadOnly)
                }
                Text("End date: \(viewModel.endDate.shortFormatted)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .rowCard()

            // Photo
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text("Photo").font(.caption).foregroundStyle(.secondary)
                HStack(spacing: Spacing.m) {
                    if let image = viewModel.selectedPhoto {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: Sizing.xxl, height: Sizing.xxl)
                            .clipShape(RoundedRectangle(cornerRadius: Sizing.s))
                    } else {
                        Image(systemName: "photo")
                            .font(.title2)
                            .foregroundStyle(.secondary)
                            .frame(width: Sizing.xxl, height: Sizing.xxl)
                    }
                    if !viewModel.isReadOnly {
                        PhotosPicker(selection: $selectedItem, matching: .images) {
                            Text(viewModel.selectedPhoto == nil ? "Choose Photo" : "Change Photo")
                                .font(.subheadline)
                        }
                        .onChange(of: selectedItem) { _, newValue in
                            Task { await viewModel.loadPhoto(from: newValue) }
                        }
                    }
                }
            }
            .rowCard()
        }
    }

    private var shareButton: some View {
        Button {
            viewModel.preparePDF()
            isSharing = true
        } label: {
            Label("Share with client", systemImage: "square.and.arrow.up")
                .frame(maxWidth: .infinity)
                .padding(Spacing.m)
                .background(Color.accentColor)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .padding(.horizontal, Spacing.m)
        .padding(.bottom, Spacing.s)
    }
}

// MARK: - Row styling

private extension View {
    func rowCard() -> some View {
        self
            .padding(Spacing.m)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal, Spacing.m)
    }
}

// MARK: - UIActivityViewController wrapper

private struct ShareSheet: UIViewControllerRepresentable {

    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
