import Vapor
import Fluent
import FluentMongoDriver

// configures your application
func configure(_ app: Application) throws {
	
	// Configure MongoDB database
	try app.databases.use(.mongo(
		connectionString: "add your mongo"), as: .mongo)
	
	// Register routes
	try app.routes.register(collection: FeatureFlagController())
}
