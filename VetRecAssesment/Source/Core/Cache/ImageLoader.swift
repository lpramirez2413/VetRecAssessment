import SwiftUI

@MainActor
final class ImageLoader: ObservableObject {

    @Published var imageData: Data?
    @Published var isLoading = false

    private let cache = ImageCache.shared

    func load(from urlString: String) async {
        if let cached = cache.data(for: urlString) {
            imageData = cached
            return
        }

        guard let url = URL(string: urlString) else { return }

        isLoading = true
        defer { isLoading = false }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            cache.store(data, for: urlString)
            imageData = data
        } catch {
            print("ImageLoader failed: \(error.localizedDescription)")
        }
    }
}
