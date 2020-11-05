//
//  File.swift
//  
//
//  Created by Yannis Lang on 01/11/2020.
//

import Vapor
import Fluent

final class City: Model, Content {
    static let schema = "cities"

    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Siblings(through: UserCity.self, from: \.$city, to: \.$user)
    public var users: [User]
    
    @Siblings(through: PromoCity.self, from: \.$city, to: \.$promo)
    public var promos: [Promo]

    init() {
    }
    
    init(id: UUID? = nil, name: String) {
        self.id = id
        self.name = name
    }
}
