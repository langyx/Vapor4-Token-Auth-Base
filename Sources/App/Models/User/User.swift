//
//  File.swift
//  
//
//  Created by Yannis Lang on 31/10/2020.
//

import Fluent
import Vapor

final class User: Model, Content {
    static let schema = "users"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "firstName")
    var firstName: String
    
    @Field(key: "lastName")
    var lastName: String

    @Field(key: "email")
    var email: String

    @Field(key: "password_hash")
    var passwordHash: String
    
    @Field(key: "role")
    var role: Role
    
    @Children(for: \.$user)
    var tokens: [UserToken]
    
    @Children(for: \.$user)
    var checkIns: [CheckIn]
    
    @Siblings(through: UserCity.self, from: \.$user, to: \.$city)
    public var cities: [City]
    
    @Siblings(through: PromoUser.self, from: \.$user, to: \.$promo)
    public var promos: [Promo]

    init() { }

    init(id: UUID? = nil, firstName: String, lastName: String, email: String, passwordHash: String, role: Role) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.passwordHash = passwordHash
        self.role = role
    }
}
