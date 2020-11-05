//
//  File.swift
//  
//
//  Created by Yannis Lang on 31/10/2020.
//

import Vapor

extension User {
    struct Create: Content {
        var firstName: String
        var lastName: String
        var email: String
        var password: String
    }
}

extension User.Create: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("firstName", as: String.self, is: .count(4...))
        validations.add("lastName", as: String.self, is: .count(4...))
        validations.add("email", as: String.self, is: .email)
        validations.add("password", as: String.self, is: .count(4...))
    }
}

