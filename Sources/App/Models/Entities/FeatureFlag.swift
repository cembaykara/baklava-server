//
//  FeatureFlag.swift
//  
//
//  Created by Baris Cem Baykara on 20.04.2024.
//

import Foundation
import Vapor
import Fluent

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
