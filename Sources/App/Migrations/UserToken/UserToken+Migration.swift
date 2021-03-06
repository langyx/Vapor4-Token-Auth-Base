//
//  File.swift
//  
//
//  Created by Yannis Lang on 01/11/2020.
//

import Fluent

extension UserToken {
    struct Migration: Fluent.Migration {
        var name: String { "CreateUserToken" }

        func prepare(on database: Database) -> EventLoopFuture<Void> {
            database.schema("user_tokens")
                .id()
                .field("value", .string, .required)
                .field("user_id", .uuid, .required, .references("users", "id"))
                .unique(on: "value")
                .create()
        }

        func revert(on database: Database) -> EventLoopFuture<Void> {
            database.schema("user_tokens").delete()
        }
    }
}
