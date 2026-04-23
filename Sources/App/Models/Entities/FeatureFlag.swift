//
//  FeatureFlag.swift
//  
//
//  Created by Baris Cem Baykara on 20.04.2024.
//

import Foundation
import Vapor
import Fluent

/// `Sendable` copy of persisted fields for the `FlagStore` actor.
struct FeatureFlagSnapshot: Sendable, Equatable {
    let id: UUID
    let name: String
    let enabled: Bool
}

final class FeatureFlag: Model, Content {
	static let schema = "feature_flags"
	
	@ID(key: .id) var id: UUID?
	@Field(key: "name") var name: String
	@Field(key: "enabled") var enabled: Bool
	
	init() {}
	
	init(id: UUID? = nil, name: String, enabled: Bool) {
		self.id = id
		self.name = name
		self.enabled = enabled
	}
}

extension FeatureFlag {
    /// Copies current field values into a snapshot for the in-memory `FlagStore` actor.
    func makeSnapshot() -> FeatureFlagSnapshot? {
        guard let id = id else { return nil }
        return FeatureFlagSnapshot(id: id, name: name, enabled: enabled)
    }

    static func fromSnapshot(_ snapshot: FeatureFlagSnapshot) -> FeatureFlag {
        FeatureFlag(id: snapshot.id, name: snapshot.name, enabled: snapshot.enabled)
    }
}
