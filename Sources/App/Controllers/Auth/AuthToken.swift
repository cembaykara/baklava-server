//
//  AuthToken.swift
//  baklava-server
//
//  Created by Baris Cem Baykara on 20.09.2024.
//

import Vapor
import JWT

struct AuthToken: JWTPayload {
    
    enum CodingKeys: String, CodingKey {
        case subject = "sub"
        case expiration = "exp"
    }

    var subject: SubjectClaim
    var expiration: ExpirationClaim

    init(subject: SubjectClaim, expiration: ExpirationClaim) {
        self.subject = subject
        self.expiration = expiration
    }

    func verify(using algorithm: some JWTAlgorithm) async throws {
        try expiration.verifyNotExpired()
    }
}

struct AuthMiddleware: AsyncMiddleware {
    func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
        guard let bearer = request.headers.bearerAuthorization else {
            return Response(status: .unauthorized)
        }
        
        do {
            try await request.jwt.verify(bearer.token, as: AuthToken.self)
            return try await next.respond(to: request)
        } catch {
            return Response(status: .unauthorized)
        }
    }
}
