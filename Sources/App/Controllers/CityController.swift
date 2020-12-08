//
//  File.swift
//  
//
//  Created by Yannis Lang on 01/11/2020.
//

import Vapor
import Fluent

struct CityController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let cities = routes.grouped("cities")
            .grouped(UserToken.authenticator())
        
        //get cities linked to user
        cities.get(use: index)
            
        let adminCities = cities.grouped(AdminAuthMiddleware(error: Abort(.badRequest, reason: "BadRights"), authLevel: .admin))
        
        //create city
        adminCities.grouped("create").post(use: create)
        adminCities.grouped("delete").delete(use: delete)
        
        //asign cities to user
        adminCities.grouped("assign").post(use: assign)
        
        adminCities.grouped("view").post(use: get)
        
        adminCities.grouped("all").post(use: all)
        
    }
    
    func all(req: Request) -> EventLoopFuture<Array<City>> {
       return City.query(on: req.db)
            .all()
    }
    
    func index(req: Request) throws -> EventLoopFuture<Array<City>> {
        let user = try req.auth.require(User.self)
        return user.$cities.get(on: req.db)
    }
    
    func get(req: Request) throws -> EventLoopFuture<City> {
        let getCity = try req.content.decode(City.Get.self)
        return City.query(on: req.db)
            .with(\.$users)
            .with(\.$promos)
            .filter(\.$id == getCity.id)
            .first()
            .unwrap(or: Abort(.badRequest, reason: "BadCity"))
    }
    
    func create(req: Request) throws -> EventLoopFuture<City> {
        let create = try req.content.decode(City.Create.self)
        
        return City.query(on: req.db)
            .filter(\.$name == create.name.capitalized)
            .first()
            .flatMapThrowing{ findCity -> City in
                guard findCity == nil else {
                    throw Abort(.badRequest, reason: "CityAlreadyExist")
                }
                let city = City(name: create.name.capitalized)
                return city
            }
            .flatMap { city  in
                return city.save(on: req.db).map{ city }
            }
    }
    
    func delete(req: Request) throws -> EventLoopFuture<City> {
        let city = try req.content.decode(City.Delete.self)
        return City.query(on: req.db).with(\.$users)
            .filter(\.$id == city.id)
            .first()
            .flatMapThrowing{ cityLoad -> City in
                guard let cityLoad = cityLoad else{
                    throw Abort(.badRequest, reason: "BadCity")
                }
                _ = cityLoad.users.map{ user in
                    user.$cities.detach(cityLoad, on: req.db)
                }
                return cityLoad
            }.flatMap { city in
                return city.delete(on: req.db).map { city }
            }
    }
    
    func assign(req: Request) throws -> EventLoopFuture<User> {
        let assign = try req.content.decode(City.Assign.self)
        
        var user: EventLoopFuture<User>
        if let userId = assign.userId {
             user = User.query(on: req.db)
                .filter(\.$id == userId)
                .first()
                .unwrap(or: Abort(.badRequest, reason: "UserNotFound"))
        }else{
            user = req.eventLoop.makeSucceededFuture(try req.auth.require(User.self))
        }
        
        let cities = assign.citiesId.map{ cityId in
            return City.query(on: req.db)
                .filter(\.$id == cityId)
                .first()
        }
        
        return user.flatMapThrowing{ user -> User in
            _ = cities.map{ cityLoop in
                cityLoop.flatMapThrowing { city in
                    guard let city = city else{
                        throw Abort(.badRequest, reason: "BadCityId")
                    }
                    if assign.reverse {
                        _ = city.$users.detach(user, on: req.db)
                    }else{
                        _ = city.$users.attach(user, method: .ifNotExists, on: req.db)
                    }
                }
            }
            return user
        }
    }
}


