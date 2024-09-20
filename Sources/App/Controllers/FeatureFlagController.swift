//
//  FeatureFlagController.swift
//
//
//  Created by Baris Cem Baykara on 20.04.2024.
//

import Foundation
import Vapor
import Fluent
import JWT

struct FeatureFlagController: RouteCollection {
	
	func boot(routes: RoutesBuilder) throws {
		let flagsRoute = routes.grouped("flags")
        let protectedRoutes = flagsRoute.grouped(AuthMiddleware())
        protectedRoutes.post(use: create)
        protectedRoutes.put(":id", use: update)
        protectedRoutes.get(":id", use: getFlag)
        protectedRoutes.get(use: list)
        protectedRoutes.delete(":id", use: delete)
	}
	
	@Sendable func create(req: Request) async throws -> FeatureFlag {
		let flag = try req.content.decode(FeatureFlag.self)
		try await flag.create(on: req.db)
		return flag
	}
	
	@Sendable func update(req: Request) async throws -> HTTPStatus {
		let updateWith = try req.content.decode(FeatureFlag.self)
		
		guard let id = req.parameters.get("id", as: UUID.self) else {
			throw Abort(.badRequest)
		}
		
		try await FeatureFlag.query(on: req.db)
			.filter(\.$id == id)
			.set(\.$name, to: updateWith.name)
			.set(\.$enabled, to: updateWith.enabled)
			.update()
		
		return .ok
	}
	
	@Sendable func getFlag(req: Request) async throws -> FeatureFlag {
		guard let flag = try await FeatureFlag.find(req.parameters.get("id"), on: req.db) else {
			throw Abort(.notFound)
		}
		return flag
	}
	
	@Sendable func list(req: Request) async throws -> [FeatureFlag] {
		try await FeatureFlag.query(on: req.db).all()
	}
	
	@Sendable func delete(req: Request) async throws -> HTTPStatus {
		guard let id = req.parameters.get("id", as: UUID.self) else {
			throw Abort(.badRequest)
		}
		
		try await FeatureFlag.query(on: req.db)
			.filter(\.$id == id)
			.delete()
		
		return .ok
	}
}
