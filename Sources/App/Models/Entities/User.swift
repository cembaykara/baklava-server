//
//  User.swift
//  baklava-server
//
//  Created by Baris Cem Baykara on 20.09.2024.
//

import Foundation
import Vapor
import Fluent

final class User: Model, Content {
    static let schema = "users"
    
    @ID(key: .id) var id: UUID?
    @Field(key: "username") var username: String
    @Field(key: "password_hash") var passwordHash: String
    
    init() { }
    
    init(id: UUID? = nil, username: String, passwordHash: String) {
        self.id = id
        self.username = username
        self.passwordHash = passwordHash
    }
}
