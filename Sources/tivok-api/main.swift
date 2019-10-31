import Vapor

// Application configuration
private func app(_ env: Environment) throws -> Application {
	let config = Config.default()
	let env = env
	var services = Services.default()
	
	// Router configuration
	let router = EngineRouter.default()
	services.register(router, as: Router.self)
	
	return try Application(config: config, environment: env, services: services)
}

// Run the application
try app(.detect()).run()
