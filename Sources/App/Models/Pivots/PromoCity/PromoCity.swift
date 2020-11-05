//
//  File.swift
//  
//
//  Created by Yannis Lang on 02/11/2020.
//

import Vapor
import Fluent

final class PromoCity: Model {
    static let schema = "promo+city"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "promo_id")
    var promo: Promo
    
    @Parent(key: "city_id")
    var city: City
    
    init() {
        
    }
    
    init(id: UUID? = nil, promo: Promo, city: City) throws {
        self.id = id
        self.$promo.id = try promo.requireID()
        self.$city.id = try city.requireID()
    }
}
