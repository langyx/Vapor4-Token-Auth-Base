//
//  File.swift
//  
//
//  Created by Yannis Lang on 01/11/2020.
//

import Vapor
import Fluent

final class UserCity: Model {
    static let schema = "user+city"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "user_id")
    var user: User
    
    @Parent(key: "city_id")
    var city: City
    
    init() {
        
    }
    
    init(id: UUID? = nil, user: User, city: City) throws {
        self.id = id
        self.$user.id = try user.requireID()
        self.$city.id = try city.requireID()
    }
}
