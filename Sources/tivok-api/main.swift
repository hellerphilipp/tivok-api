import Vapor
import FluentPostgreSQL

// Application configuration
private func app(_ env: Environment) throws -> Application {
	let config = Config.default()
	let env = env
	var services = Services.default()
	
	// Router configuration
	let router = EngineRouter.default()
	services.register(router, as: Router.self)
	
	// Database configuration
	let dbConfig = PostgreSQLDatabaseConfig(
		hostname: try EnvLoader.get("DB_HOST"),
		port: try EnvLoader.getAsInt("DB_PORT"),
		username: try EnvLoader.get("DB_USER"),
		database: try EnvLoader.get("DB_DATABASE"),
		password: try EnvLoader.get("DB_PASSWORD")
	)
	try services.register(PostgreSQLProvider())
	services.register(dbConfig)
	
	
	return try Application(config: config, environment: env, services: services)
}

// Run the application
try app(.detect()).run()
