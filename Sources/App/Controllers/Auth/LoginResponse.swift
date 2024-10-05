//
//  LoginResponse.swift
//  baklava-server
//
//  Created by Baris Cem Baykara on 21.09.2024.
//

import Vapor

struct LoginResponse: Content {
    let authToken: String
}
