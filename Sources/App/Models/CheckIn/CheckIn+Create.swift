//
//  File.swift
//  
//
//  Created by Yannis Lang on 04/11/2020.
//

import Vapor
import Fluent

extension CheckIn {
    struct Create: Content {
        var user: UUID
        var promo: UUID
    }
}
