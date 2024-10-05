//
//  RegisterRequest.swift
//  baklava-server
//
//  Created by Baris Cem Baykara on 20.09.2024.
//

import Vapor

struct RegisterRequest: Content {
    let username: String
    let password: String
}
