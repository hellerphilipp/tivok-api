import Vapor
import FluentPostgreSQL
import Authentication

// Application configuration
private func app(_ env: Environment) throws -> Application {
	let config = Config.default()
	let env = env
	var services = Services.default()
	
	var middlewares = MiddlewareConfig()
	
	if(env != .production) {
		let corsConfiguration = CORSMiddleware.Configuration(
			allowedOrigin: .all,
			allowedMethods: [.GET, .POST, .PUT, .OPTIONS, .DELETE, .PATCH],
			allowedHeaders: [.accept, .authorization, .contentType, .origin, .xRequestedWith, .userAgent, .accessControlAllowOrigin]
		)
		let corsMiddleware = CORSMiddleware(configuration: corsConfiguration)
		middlewares.use(corsMiddleware)
		middlewares.use(ErrorMiddleware.self)
	}
	services.register(middlewares)
	
	// Router configuration
	let router = EngineRouter.default()
	try routes(router)
	services.register(router, as: Router.self)
	
	// Database configuration
	let dbConfig = PostgreSQLDatabaseConfig(
		hostname: try EnvLoader.get("DB_HOST"),
		port: try EnvLoader.getAsInt("DB_PORT"),
		username: try EnvLoader.get("DB_USER"),
		database: try EnvLoader.get("DB_DATABASE"),
		password: try EnvLoader.get("DB_PASSWORD")
	)
	try services.register(FluentPostgreSQLProvider())
	services.register(dbConfig)
	
	// Register database migrations
	var migrations = MigrationConfig()
	migrations.add(model: User.self, database: .psql)
	migrations.add(model: Event.self, database: .psql)
	services.register(migrations)
	
	// Register Authentication Provider
	try services.register(AuthenticationProvider())
	
	// Register JWTUtil to pre-load JWKs
	try services.register(JWTUtil(for: try EnvLoader.get("JWT_TENANT")))
	
	return try Application(config: config, environment: env, services: services)
}

// Run the application
try app(.detect()).run()
