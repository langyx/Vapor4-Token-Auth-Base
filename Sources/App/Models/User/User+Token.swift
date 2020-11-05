//
//  File.swift
//  
//
//  Created by Yannis Lang on 01/11/2020.
//

import Vapor
import Fluent

extension User {
    func generateToken() throws -> UserToken {
        try .init(
            value: [UInt8].random(count: 16).base64,
            userID: self.requireID()
        )
    }
}
