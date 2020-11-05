//
//  File.swift
//  
//
//  Created by Yannis Lang on 31/10/2020.
//

import Vapor
import Fluent

extension User: ModelAuthenticatable {
    static let usernameKey = \User.$email
    static let passwordHashKey = \User.$passwordHash

    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.passwordHash)
    }
}
