import Foundation

enum AppError: Error, Equatable {
    case decodingFailed
    case persistenceFailed
    case fileNotFound
    case unknown(String)

    var message: String {
        switch self {
        case .decodingFailed:
            return "Failed to decode data"
        case .persistenceFailed:
            return "Failed to save data"
        case .fileNotFound:
            return "Resource not found"
        case .unknown(let msg):
            return msg
        }
    }
}
