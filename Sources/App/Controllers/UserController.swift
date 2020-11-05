//
//  File.swift
//  
//
//  Created by Yannis Lang on 31/10/2020.
//

import Vapor
import Fluent

//https://docs.vapor.codes/4.0/authentication/ user token

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let users = routes.grouped("users")
        
        let usersPasswordProtected = users.grouped("login").grouped(User.authenticator())
        usersPasswordProtected.post(use: login)
        
        let usersCreate = users.grouped("create")
        usersCreate.post(use: index)
        
        let tokenProtected = users.grouped(UserToken.authenticator())
        let meGroup = tokenProtected.grouped("me")
        meGroup.get(use: me)
        
        
    }
    
    func index(req: Request) throws -> EventLoopFuture<User> {
        try User.Create.validate(content: req)
        let create = try req.content.decode(User.Create.self)
        
        return User.query(on: req.db)
            .filter(\.$email == create.email)
            .first()
            .flatMapThrowing{ findUser -> User in
                guard findUser == nil else {
                    throw Abort(.badRequest, reason: "UserAlreadyExist")
                }
                let user = try User(
                    firstName: create.firstName,
                    lastName: create.lastName,
                    email: create.email,
                    passwordHash: Bcrypt.hash(create.password),
                    role: .student
                )
                return user
            }
            .flatMap { user  in
                return user.save(on: req.db).map{ user }
            }
    }
    
    func login(req: Request) throws -> EventLoopFuture<UserToken> {
        let user = try req.auth.require(User.self)
        return user.$tokens.query(on: req.db)
            .first()
            .flatMapThrowing { findToken -> UserToken in
                _ = findToken?.delete(on: req.db)
                let token = try user.generateToken()
                return token
            }
            .flatMap{ token in
                return token.save(on: req.db)
                    .map { token }
            }
    }
    
    func me(req: Request) throws -> EventLoopFuture<User> {
        let user = try req.auth.require(User.self)
        
        guard let userId = user.id else {
            throw Abort(.badRequest, reason: "BadUser")
        }
        
        return User.query(on: req.db)
            .with(\.$cities)
            .with(\.$promos)
            .filter(\.$id == userId)
            .first()
            .unwrap(or: Abort(.badRequest, reason: "BadUser"))
    }
}
