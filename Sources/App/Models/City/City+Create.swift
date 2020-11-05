//
//  File.swift
//  
//
//  Created by Yannis Lang on 01/11/2020.
//

import Vapor
import Fluent

extension City {
    struct Create: Content {
        var name: String
    }
    
    struct Delete: Content {
        var id: UUID
    }
}

extension City.Create: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("name", as: String.self, is: .count(4...))
    }
}

extension City.Delete: Validatable {
    static func validations(_ validations: inout Validations) {
    }
}
