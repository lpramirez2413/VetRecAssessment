import SwiftUI

struct CachedImageView: View {
    let urlString: String
    var size: CGFloat = Sizing.xl

    @StateObject private var loader = ImageLoader()

    var body: some View {
        Group {
            if let data = loader.imageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else if loader.isLoading {
                ProgressView()
            } else {
                Image(systemName: "pawprint.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.secondary)
                    .padding(Spacing.s)
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
        .task {
            await loader.load(from: urlString)
        }
    }
}
