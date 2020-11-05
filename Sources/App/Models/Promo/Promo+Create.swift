//
//  File.swift
//  
//
//  Created by Yannis Lang on 02/11/2020.
//

import Vapor
import Fluent

extension Promo {
    struct Create: Content {
        var name: String
        var checkIns: [Time]
        var cityId: [UUID]
        var start: Date
        var end: Date
    }
    
    struct Delete: Content {
        var id: [UUID]
    }
}

extension Promo.Create: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("name", as: String.self, is: .count(4...))
        validations.add("checkIns", as: [Promo.Time].self)
    }
}

extension Promo.Delete: Validatable {
    static func validations(_ validations: inout Validations) {
    }
}
