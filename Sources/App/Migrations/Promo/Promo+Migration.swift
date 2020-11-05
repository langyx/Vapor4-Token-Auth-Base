//
//  File.swift
//  
//
//  Created by Yannis Lang on 02/11/2020.
//

import Vapor
import Fluent

extension Promo {
    struct Migration: Fluent.Migration {
        var name: String { "CreatePromo" }

        func prepare(on database: Database) -> EventLoopFuture<Void> {
            database.schema("promos")
                .id()
                .field("name", .string, .required)
                .field("checkIns", .array(of: .json), .required)
                .create()
        }

        func revert(on database: Database) -> EventLoopFuture<Void> {
            database.schema("promos").delete()
        }
    }
    
    struct UpdatePromoStartEnd: Fluent.Migration {
        var name: String { "UpdatePromoStartEnd" }

        func prepare(on database: Database) -> EventLoopFuture<Void> {
            database.schema("promos")
                .field("start", .date)
                .field("end", .date)
                .update()
        }

        func revert(on database: Database) -> EventLoopFuture<Void> {
            database.schema("promos")
                .deleteField("start")
                .deleteField("end")
                .update()
        }
    }
}
