import Fluent
import Vapor

func routes(_ app: Application) throws {
    try app.register(collection: UserController())
    try app.register(collection: CityController())
    try app.register(collection: PromoController())
    try app.register(collection: CheckInController())
}
