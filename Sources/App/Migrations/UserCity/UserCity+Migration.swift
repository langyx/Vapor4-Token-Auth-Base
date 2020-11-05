//
//  File.swift
//  
//
//  Created by Yannis Lang on 01/11/2020.
//

import Vapor
import Fluent

struct CreateUserCityPivot: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("user+city")
            .id()
            .field("user_id", .uuid, .required, .references("users", "id"))
            .field("city_id", .uuid, .required, .references("cities", "id"))
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("user+city").delete()
    }
}

struct UpdateUserCityDuplicate: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("user+city")
            .unique(on: "user_id", "city_id")
            .update()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("user+city").delete()
    }
}
