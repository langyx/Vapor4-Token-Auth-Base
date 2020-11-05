//
//  File.swift
//  
//
//  Created by Yannis Lang on 02/11/2020.
//

import Vapor
import Fluent

final class Promo: Model, Content {
    static let schema = "promos"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "checkIns")
    var checkIns: [Time]
    
    @Siblings(through: PromoCity.self, from: \.$promo, to: \.$city)
    public var cities: [City]
    
    @Siblings(through: PromoUser.self, from: \.$promo, to: \.$user)
    public var users: [User]
    
    @Field(key: "start")
    var start: Date
    
    @Field(key: "end")
    var end: Date
    
    @Children(for: \.$promo)
    var checkInUsers: [CheckIn]
    
    struct Time: Codable {
        var hour: Int
        var minute: Int
        
        init(hour: Int, minute: Int) {
            self.hour = hour
            self.minute = minute
        }
    }
    
    init() {
    }
    
    init(id: UUID? = nil, name: String, checkIns: [Time] = [Time](), start: Date, end: Date) {
        self.id = id
        self.name = name
        self.checkIns = checkIns
        self.start = start
        self.end = end
    }
    
    
}
