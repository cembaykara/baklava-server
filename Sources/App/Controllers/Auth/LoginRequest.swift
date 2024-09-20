//
//  LoginRequest.swift
//  baklava-server
//
//  Created by Baris Cem Baykara on 20.09.2024.
//

import Vapor

struct LoginRequest: Content {
    let username: String
    let password: String
}
