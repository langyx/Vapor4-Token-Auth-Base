import Fluent
import FluentPostgresDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    if let databaseURL = Environment.get("DATABASE_URL"), var postgresConfig = PostgresConfiguration(url: databaseURL) {
        postgresConfig.tlsConfiguration = .forClient(certificateVerification: .none)
        app.databases.use(.postgres(
            configuration: postgresConfig
        ), as: .psql)
    } else {
        
    }
    
    app.migrations.add(User.Migration())
    app.migrations.add(UserToken.Migration())
    app.migrations.add(User.AddRoleMigration())
    app.migrations.add(City.Migration())
    app.migrations.add(CreateUserCityPivot())
    app.migrations.add(UpdateUserCityDuplicate())
    app.migrations.add(Promo.Migration())
    app.migrations.add(CreatePromoCityPivot())
    app.migrations.add(CreatePromoUserPivot())
    app.migrations.add(Promo.UpdatePromoStartEnd())
    app.migrations.add(CheckIn.Migration())
    app.migrations.add(CheckIn.UpdateFieldToDateTime())

    // register routes
    try routes(app)
}
