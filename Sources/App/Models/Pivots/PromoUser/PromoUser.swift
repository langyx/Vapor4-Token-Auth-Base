//
//  File.swift
//  
//
//  Created by Yannis Lang on 02/11/2020.
//

import Vapor
import Fluent

final class PromoUser: Model {
    static let schema = "promo+user"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "promo_id")
    var promo: Promo
    
    @Parent(key: "user_id")
    var user: User
    
    init() {
        
    }
    
    init(id: UUID? = nil, promo: Promo, user: User) throws {
        self.id = id
        self.$promo.id = try promo.requireID()
        self.$user.id = try user.requireID()
    }
}
