//
//  SwiftUIView.swift
//  
//
//  Created by Yannis Lang on 03/11/2020.
//

import Vapor
import Fluent

extension Promo {
    struct Assign: Content {
        var promos: [UUID]
        var users: [UUID]
        var reverse: Bool
    }
}

