import Vapor
import Fluent
import FluentMongoDriver
import JWT

func configure(_ app: Application) async throws {
    
    //GET .env values
    guard let signingKey = Environment.get("JWT_SIGNING_KEY") else { fatalError() }
    guard let dbURI = Environment.get("DB_URI") else { fatalError() }
	
    // Configure MongoDB database
	try app.databases.use(.mongo(
		connectionString: dbURI), as: .mongo)
    
    //Add JWT Signer
    await app.jwt.keys.add(hmac: .init(stringLiteral: signingKey), digestAlgorithm: .sha256)
	
    // Register routes
	try app.routes.register(collection: FeatureFlagController())
    try app.routes.register(collection: AuthController())
}
