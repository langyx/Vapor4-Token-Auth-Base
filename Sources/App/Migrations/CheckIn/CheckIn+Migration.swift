//
//  File.swift
//  
//
//  Created by Yannis Lang on 03/11/2020.
//

import Vapor
import Fluent

extension CheckIn {
    struct Migration: Fluent.Migration {
        var name: String { "CreateCheckin" }

        func prepare(on database: Database) -> EventLoopFuture<Void> {
            database.schema("checkins")
                .id()
                .field("time", .date, .required)
                .field("user_id", .uuid, .references("users", "id"))
                .field("promo_id", .uuid, .references("promos", "id"))
                .create()
        }

        func revert(on database: Database) -> EventLoopFuture<Void> {
            database.schema("checkins").delete()
        }
    }
    
    struct UpdateFieldToDateTime: Fluent.Migration {
        var name: String { "UpdateFieldToDateTime" }

        func prepare(on database: Database) -> EventLoopFuture<Void> {
            database.schema("checkins")
                .updateField("time", .datetime)
                .update()
        }

        func revert(on database: Database) -> EventLoopFuture<Void> {
            database.schema("checkins").updateField("time", .date).update()
        }
    }
}
