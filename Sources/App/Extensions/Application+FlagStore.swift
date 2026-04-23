import Vapor

extension Application {
    struct FlagStoreKey: StorageKey {
        typealias Value = FlagStore
    }

    var flagStore: FlagStore {
        get {
            guard let store = storage[FlagStoreKey.self] else {
                fatalError("FlagStore not configured. Call configure FlagStore before routes.")
            }
            return store
        }
        set {
            storage[FlagStoreKey.self] = newValue
        }
    }
}
