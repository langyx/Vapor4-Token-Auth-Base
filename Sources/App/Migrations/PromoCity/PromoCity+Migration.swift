//
//  File.swift
//  
//
//  Created by Yannis Lang on 02/11/2020.
//

import Vapor
import Fluent

struct CreatePromoCityPivot: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("promo+city")
            .id()
            .field("promo_id", .uuid, .required, .references("promos", "id"))
            .field("city_id", .uuid, .required, .references("cities", "id"))
            .unique(on: "promo_id", "city_id")
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("promo+city").delete()
    }
}
