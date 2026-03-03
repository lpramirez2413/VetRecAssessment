import SwiftUI

struct PrescriptionRow: View {

    let prescription: Prescription

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(prescription.title)
                    .font(.headline)
                Text("\(prescription.medicationName) \(prescription.dosage)\(prescription.dosageUnit)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(prescription.startDate.shortFormatted)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, Spacing.xs)
    }
}
