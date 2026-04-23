import Foundation

/// In-memory authoritative read model for feature flags (single-instance).
/// Database access stays outside this actor; callers pass `FeatureFlagSnapshot` values only.
actor FlagStore {
    private var flagsById: [UUID: FeatureFlagSnapshot] = [:]

    func reload(snapshots: [FeatureFlagSnapshot]) {
        var next: [UUID: FeatureFlagSnapshot] = [:]
        for snapshot in snapshots {
            next[snapshot.id] = snapshot
        }
        flagsById = next
    }

    func list() -> [FeatureFlagSnapshot] {
        flagsById.values.sorted { $0.name < $1.name }
    }

    func get(id: UUID) -> FeatureFlagSnapshot? {
        flagsById[id]
    }

    func upsert(_ snapshot: FeatureFlagSnapshot) {
        flagsById[snapshot.id] = snapshot
    }

    func remove(id: UUID) {
        flagsById[id] = nil
    }
}
