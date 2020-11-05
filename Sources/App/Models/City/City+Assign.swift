//
//  File.swift
//  
//
//  Created by Yannis Lang on 01/11/2020.
//
import Vapor

extension City {
    struct Assign: Content {
        var citiesId: [UUID]
        var userId: UUID?
        var reverse: Bool
    }
}

extension City.Assign: Validatable {
    static func validations(_ validations: inout Validations) {
        //validations.add("cityId", as: String.self, is: !.empty)
    }
}
