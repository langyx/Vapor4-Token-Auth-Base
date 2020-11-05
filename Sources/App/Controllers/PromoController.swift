//
//  File.swift
//  
//
//  Created by Yannis Lang on 02/11/2020.
//

import Vapor
import Fluent

struct PromoController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let promos = routes.grouped("promos")
            .grouped(UserToken.authenticator())
        let adminPromos = promos.grouped(AdminAuthMiddleware(error: Abort(.badRequest, reason: "BadRights"), authLevel: .admin))
        
        adminPromos.grouped("create").post(use: create)
        adminPromos.grouped("delete").post(use: delete)
        adminPromos.grouped("assign").post(use: assign)
    }
    
    func create(req: Request) throws -> EventLoopFuture<Promo> {
        let create = try req.content.decode(Promo.Create.self)
        let promo = Promo(name: create.name.capitalized, checkIns: create.checkIns, start: create.start, end: create.end)
        
        let cities = City.query(on: req.db)
            .filter(\.$id ~~ create.cityId)
            .all()
        
        return cities.flatMapThrowing { cities -> [City] in
            if cities.count == 0 {
                throw Abort(.badRequest, reason: "NoCityInReq")
            }
            _ = promo.save(on: req.db)
            return cities
        }.mapEach{ city -> City in
            _ = city.$promos.attach(promo, on: req.db)
            return city
        }.map{ _ in
            return promo
        }
    }
    
    func delete(req: Request) throws -> EventLoopFuture<[Promo]> {
        let delete = try req.content.decode(Promo.Delete.self)
        return Promo.query(on: req.db)
            .filter(\.$id ~~ delete.id)
            .with(\.$cities)
            .with(\.$users)
            .all()
            .flatMapEachThrowing { deletePromo -> Promo in
                _ = deletePromo.users.map{ user in
                    user.$promos.detach(deletePromo, on: req.db)
                }
                
                _ = deletePromo.cities.map { city in
                    city.$promos.detach(deletePromo, on: req.db)
                }
                _ = deletePromo.delete(on: req.db)
                return deletePromo
            }.map{ deletedPromos in
                return deletedPromos
            }
    }
    
    func assign(req: Request) throws -> EventLoopFuture<[Promo]> {
        let assign = try req.content.decode(Promo.Assign.self)
        
        let users = User.query(on: req.db)
            .filter(\.$id ~~ assign.users)
            .all()
            .map{ users in
                return users
            }
        
        return Promo.query(on: req.db)
            .filter(\.$id ~~ assign.promos)
            .all()
            .mapEach{ promo -> Promo in
                _ = users.mapEach{ user in
                    if assign.reverse {
                        _ = user.$promos.detach(promo, on: req.db)
                    }else{
                        _ = user.$promos.attach(promo, on: req.db)
                    }
                }
                return promo
            }.map{ promos in
                return promos
            }
    }
}


