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
        guard let snapshot = flag.makeSnapshot() else {
            throw Abort(.internalServerError)
        }
        await req.application.flagStore.upsert(snapshot)
		return FeatureFlag.fromSnapshot(snapshot)
	}
	
	@Sendable func update(req: Request) async throws -> HTTPStatus {
		let updateWith = try req.content.decode(FeatureFlag.self)
		
		guard let id = req.parameters.get("id", as: UUID.self) else {
			throw Abort(.badRequest)
		}

        guard await req.application.flagStore.get(id: id) != nil else {
            throw Abort(.notFound)
        }
		
		try await FeatureFlag.query(on: req.db)
			.filter(\.$id == id)
			.set(\.$name, to: updateWith.name)
			.set(\.$enabled, to: updateWith.enabled)
			.update()

        await req.application.flagStore.upsert(
            FeatureFlagSnapshot(id: id, name: updateWith.name, enabled: updateWith.enabled)
        )
		
		return .ok
	}
	
	@Sendable func getFlag(req: Request) async throws -> FeatureFlag {
        guard let id = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        guard let snapshot = await req.application.flagStore.get(id: id) else {
			throw Abort(.notFound)
		}
		return FeatureFlag.fromSnapshot(snapshot)
	}
	
	@Sendable func list(req: Request) async throws -> [FeatureFlag] {
        let snapshots = await req.application.flagStore.list()
        return snapshots.map(FeatureFlag.fromSnapshot)
	}
	
	@Sendable func delete(req: Request) async throws -> HTTPStatus {
		guard let id = req.parameters.get("id", as: UUID.self) else {
			throw Abort(.badRequest)
		}

        guard await req.application.flagStore.get(id: id) != nil else {
            throw Abort(.notFound)
        }
		
		try await FeatureFlag.query(on: req.db)
			.filter(\.$id == id)
			.delete()

        await req.application.flagStore.remove(id: id)
		
		return .ok
	}
}
