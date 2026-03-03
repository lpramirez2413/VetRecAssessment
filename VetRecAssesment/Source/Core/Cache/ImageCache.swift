import Foundation

final class ImageCache {

    static let shared = ImageCache()
    private init() {}

    private let cache = NSCache<NSString, NSData>()

    func data(for url: String) -> Data? {
        cache.object(forKey: url as NSString) as Data?
    }

    func store(_ data: Data, for url: String) {
        cache.setObject(data as NSData, forKey: url as NSString)
    }
}
