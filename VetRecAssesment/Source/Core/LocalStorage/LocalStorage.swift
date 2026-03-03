import Foundation

final class LocalStorage {

    static let shared = LocalStorage()

    private let defaults = UserDefaults.standard

    private init() {}

    private enum Keys {
        static let isFirstLaunch = "isFirstLaunch"
    }

    var isFirstLaunch: Bool {
        get {
            !defaults.bool(forKey: Keys.isFirstLaunch)
        }
        set {
            defaults.set(!newValue, forKey: Keys.isFirstLaunch)
        }
    }
}
