//
//  File.swift
//  
//
//  Created by Yannis Lang on 01/11/2020.
//

import Vapor
import Fluent

extension City {
    struct Migration: Fluent.Migration {
        var name: String { "CreateCity" }

        func prepare(on database: Database) -> EventLoopFuture<Void> {
            database.schema("cities")
                .id()
                .field("name", .string, .required)
                .create()
        }

        func revert(on database: Database) -> EventLoopFuture<Void> {
            database.schema("cities").delete()
        }
    }
}
