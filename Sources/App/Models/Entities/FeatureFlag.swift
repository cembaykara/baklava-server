//
//  FeatureFlag.swift
//  
//
//  Created by Baris Cem Baykara on 20.04.2024.
//

import Foundation
import Vapor
import Fluent

struct FeatureFlagResource: ResourceRepresentable {
    let id: UUID
    let name: String
    let enabled: Bool
    let createdAt: Date?
    let updatedAt: Date?
}

/// `Sendable` copy of persisted fields for the `FlagStore` actor.
struct FeatureFlagSnapshot: Sendable, Equatable {
    let id: UUID
    let name: String
    let enabled: Bool
    let createdAt: Date?
    let updatedAt: Date?
}

final class FeatureFlag: Model, Content {
	static let schema = "feature_flags"
	
	@ID(key: .id) var id: UUID?
	@Field(key: "name") var name: String
	@Field(key: "enabled") var enabled: Bool
    @Timestamp(key: "createdAt", on: .create) var createdAt: Date?
    @Timestamp(key: "updatedAt", on: .update) var updatedAt: Date?
	
	init() {}
	
	init(id: UUID? = nil, name: String, enabled: Bool, createdAt: Date? = nil, updatedAt: Date? = nil) {
		self.id = id
		self.name = name
		self.enabled = enabled
        self.createdAt = createdAt
        self.updatedAt = updatedAt
	}
}

extension FeatureFlag {
    /// Copies current field values into a snapshot for the in-memory `FlagStore` actor.
    func makeSnapshot() -> FeatureFlagSnapshot? {
        guard let id = id else { return nil }
        return FeatureFlagSnapshot(id: id, name: name, enabled: enabled, createdAt: createdAt, updatedAt: updatedAt)
    }
    
    func toResource() -> FeatureFlagResource? {
        guard let id = id else { return nil }
        return FeatureFlagResource(id: id, name: name, enabled: enabled, createdAt: createdAt, updatedAt: updatedAt)
    }
}

extension FeatureFlagSnapshot {
    func toResource() -> FeatureFlagResource {
        FeatureFlagResource(id: id, name: name, enabled: enabled, createdAt: createdAt, updatedAt: updatedAt)
    }
}
