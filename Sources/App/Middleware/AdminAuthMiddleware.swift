//
//  File.swift
//  
//
//  Created by Yannis Lang on 01/11/2020.
//

import Vapor

internal class AdminAuthMiddleware: Middleware {
    internal let error: Error
    internal let authLevel: Role
    public init(error: Error, authLevel: Role) {
        self.error = error
        self.authLevel = authLevel
    }
    
    public func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        if let user = try? request.auth.require(User.self) {
            if user.role.rawValue < 1 {
                return request.eventLoop.makeFailedFuture(error)
            }else{
                return next.respond(to: request)
            }
        }
        return request.eventLoop.makeFailedFuture(Abort(.badRequest, reason: "NotLogged"))
    }

}
