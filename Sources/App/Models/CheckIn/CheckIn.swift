//
//  File.swift
//  
//
//  Created by Yannis Lang on 03/11/2020.
//

import Vapor
import Fluent

final class CheckIn: Model, Content {
    static let schema = "checkins"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "time")
    var time: Date
    
    @Parent(key: "promo_id")
    var promo: Promo
    
    @Parent(key: "user_id")
    var user: User
    
    init() {
        
    }
    
    init(id: UUID? = nil, time: Date, userId: User.IDValue, promoId: Promo.IDValue) {
        self.id = id
        self.time = time
        self.$promo.id = promoId
        self.$user.id = userId
    }
}
