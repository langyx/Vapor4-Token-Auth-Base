//
//  File.swift
//  
//
//  Created by Yannis Lang on 01/11/2020.
//

import Vapor
import Fluent

enum Role: Int, Codable, RawRepresentable {
    case student = 0, admin, superadmin
}
