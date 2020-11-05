//
//  File.swift
//  
//
//  Created by Yannis Lang on 04/11/2020.
//

import Vapor
import Fluent

struct CheckInController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let checkin = routes.grouped("checkin")
            .grouped(UserToken.authenticator())
        
        checkin.grouped("add").post(use: add)
    }
    
    private func addCheckUser(req: Request, create: CheckIn.Create) throws -> EventLoopFuture<Bool> {
        User.query(on: req.db)
            .with(\.$promos)
            .filter(\.$id == create.user)
            .first()
            .unwrap(or: Abort(.badRequest, reason: "BadUser"))
            .flatMap { user in
                return user.$promos.isAttached(toID: create.promo, on: req.db)
            }
            .flatMapThrowing{
                userIn in
                guard userIn else {
                    throw Abort(.badRequest, reason: "UserNotInPromo")
                }
                return userIn
            }
    }
    
    private func addCheckUserTwice(req: Request, create: CheckIn.Create) throws -> EventLoopFuture<Bool> {
        let startInterval = Calendar.current.date(byAdding: .minute, value: -CheckInController.maxDelay, to: Date())!
        let endInterval = Calendar.current.date(byAdding: .minute, value: CheckInController.maxDelay, to: Date())!
        
        return CheckIn.query(on: req.db)
            .join(User.self, on: \CheckIn.$user.$id == \User.$id)
            .filter(User.self, \.$id == create.user)
            .filter(\.$time > startInterval)
            .filter(\.$time < endInterval)
            .count()
            .flatMapThrowing{ number -> Bool in
                let valid = number < 1
                guard valid else {
                    throw Abort(.badRequest, reason: "AlreadyCheckedIn")
                }
                return valid
            }
    }
    
    private func addCheckInFinal(req: Request, create: CheckIn.Create) throws -> EventLoopFuture<CheckIn> {
        return Promo.query(on: req.db)
            .filter(\.$id == create.promo)
            .first()
            .unwrap(or: Abort(.badRequest, reason: "BadPromo"))
            .flatMapThrowing{ promo -> CheckIn in
                var validDate: Date? = nil
                try promo.checkIns.forEach { time in
                    let dateForTime = Calendar.current.date(bySettingHour: time.hour, minute: time.minute, second: 0, of: Date())!
                    guard (promo.start ... promo.end).contains(dateForTime) else {
                        throw Abort(.badRequest, reason: "CheckInOutOfDate")
                    }
                    guard (Calendar.current.dateComponents([.weekday], from: dateForTime).weekday ?? 7) < 6 else {
                        throw Abort(.badRequest, reason: "CheckInOutOfWeek")
                    }
                    guard let delay = Calendar.current.dateComponents([.minute], from: dateForTime, to: Date()).minute else{
                        throw Abort(.badRequest, reason: "ErrorGetDelay")
                    }
                    if abs(delay) < CheckInController.maxDelay {
                        validDate = Date()
                        return
                    }
                }
                
                guard validDate != nil else {
                    throw Abort(.badRequest, reason: "CheckInNotOpen")
                }
                
                let checkIn = CheckIn(time: Date(), userId: create.user, promoId: create.promo)
                _ = checkIn.save(on: req.db)
                return checkIn
            }
    }
    
    func add(req: Request) throws -> EventLoopFuture<CheckIn> {
        let create = try req.content.decode(CheckIn.Create.self)
        
        let checkUser =  try addCheckUser(req: req, create: create)
            .flatMapThrowing{ valid in
                return try addCheckUserTwice(req: req, create: create).flatMapThrowing{
                    valid in
                    return try addCheckInFinal(req: req, create: create)
                }.flatMap{ checkIn in
                    return checkIn
                }
            }
        
        return checkUser.flatMap{
            checkIn in
            return checkIn
        }
        
    }
}

extension CheckInController {
    static let maxDelay = 10
}
