//
//  File.swift
//  
//
//  Created by Yannis Lang on 02/11/2020.
//

import Vapor
import Fluent

struct CreatePromoUserPivot: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("promo+user")
            .id()
            .field("promo_id", .uuid, .required, .references("promos", "id"))
            .field("user_id", .uuid, .required, .references("users", "id"))
            .unique(on: "promo_id", "user_id")
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("promo+user").delete()
    }
}
