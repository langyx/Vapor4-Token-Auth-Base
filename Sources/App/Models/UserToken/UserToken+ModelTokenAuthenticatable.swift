//
//  File.swift
//  
//
//  Created by Yannis Lang on 01/11/2020.
//

import Vapor
import Fluent

extension UserToken: ModelTokenAuthenticatable {
    static let valueKey = \UserToken.$value
    static let userKey = \UserToken.$user

    var isValid: Bool {
        true
    }
}
