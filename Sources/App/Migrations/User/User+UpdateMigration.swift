//
//  File.swift
//  
//
//  Created by Yannis Lang on 01/11/2020.
//

import Vapor
import Fluent
import FluentPostgresDriver

extension User {
    struct AddRoleMigration : Fluent.Migration {

        func prepare(on database: Database) -> EventLoopFuture<Void> {
            database.schema("users")
                .field("role", .int)
                .update()
        }

        func revert(on database: Database) -> EventLoopFuture<Void> {
            database.schema("users").delete()
        }
    }
}
