import SwiftUI

struct PetRow: View {

    let pet: Pet

    var body: some View {
        HStack(spacing: Spacing.s) {
            leadingContent
            Spacer()
            trailingContent
        }
        .padding(.leading, Spacing.xs)
        .padding(.trailing, Spacing.m)
    }
    
    private var leadingContent: some View {
        HStack(spacing: Spacing.s) {
            CachedImageView(urlString: pet.imageURL)
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(pet.name)
                    .font(.headline)
                Text(pet.species.displayName)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    private var trailingContent: some View {
        VStack {
            HStack(spacing: Spacing.s) {
                Image(systemName: "person.fill")
                    .resizable()
                    .frame(width: 10, height: 10)
                Text(pet.clientName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(.vertical, Spacing.s)
    }
}
