//
//  AuthController.swift
//  baklava-server
//
//  Created by Baris Cem Baykara on 20.09.2024.
//
import Vapor
import Fluent
import JWT

struct AuthController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let authRoutes = routes.grouped("auth")

        authRoutes.post("login", use: login)
        authRoutes.post("register", use: register)
    }
    
    @Sendable func login(req: Request) async throws -> LoginResponse {
        let loginRequest = try req.content.decode(LoginRequest.self)
        
        guard let user = try await User.query(on: req.db)
            .filter(\.$username == loginRequest.username)
            .first()
        else { throw Abort(.unauthorized) }
        
        guard try req.password.verify(loginRequest.password, created: user.passwordHash) else {
            throw Abort(.unauthorized)
        }
        
        let expirationDate = Date().addingTimeInterval(60 * 60 * 24 * 30) // 1 month from now
        
        let payload = AuthToken(
            subject: SubjectClaim(value: user.id?.uuidString ?? ""),
            expiration: ExpirationClaim(value: expirationDate)
        )
        
        let signedToken = try await req.jwt.sign(payload)
        
        return LoginResponse(authToken: signedToken)
    }
    
    @Sendable func register(req: Request) async throws -> RegisterResponse {
        let registerRequest = try req.content.decode(RegisterRequest.self)
        
        let existingUser = try await User.query(on: req.db)
            .filter(\.$username == registerRequest.username)
            .first()

        if existingUser != nil {
            throw Abort(.conflict)
        }
        
        let passwordHash = try? req.password.hash(registerRequest.password)
        guard let hash = passwordHash else {
            throw Abort(.internalServerError)
        }
        
       let newUser = User(
            username: registerRequest.username,
            passwordHash: hash
        )
        
        do {
            try await newUser.create(on: req.db)
        } catch {
            throw Abort(.internalServerError)
        }
        
        
        return RegisterResponse(success: true)
    }
}
