//
//  UserController.swift
//  Control Incoming Requests to user-related routes
//
//  Created by Philipp Heller on 03.11.19.
//

import Vapor

class UserController: RouteCollection {
	func boot(router: Router) throws {
		let protected = router.grouped(JWTMiddleware()) // TODO: Make JWTMiddleware a service
		protected.get("users", use: getUsers)
		protected.get("users", User.parameter, use: getUser)
		protected.put("users", User.parameter, use: updateUser)
	}
	
	func getUsers(req: Request) throws -> Future<HTTPResponse> {
		if let _ = try? req.query.get(Bool.self, at: "self") {
			let user = try req.requireAuthenticated(User.self)
			
			return req.future(HTTPResponse(status: .movedPermanently, headers: ["Location": "\(req.http.url.path)/\(try user.requireID())"]))
		} else {
			return User.query(on: req).decode(data: User.self).all().map { users -> HTTPResponse in
				return HTTPResponse(status: .ok, headers: ["Content-Type": "application/json; charset=utf-8"], body: try JSONEncoder().encode(users))
			}
		}
	}
	
	func getUser(req: Request) throws -> Future<User> {
		return try req.parameters.next(User.self)
	}
	
	func updateUser(req: Request) throws -> Future<HTTPResponse> {
		let authenticated = try req.requireAuthenticated(User.self)
		
		return try req.parameters.next(User.self).flatMap { toUpdate in
			if(authenticated.id != toUpdate.id) {
				return req.future(HTTPResponse(status: .unauthorized))
			}
			
			struct UpdatableUser: Decodable {
				var lastEvent: Event.ID?
			}
			
			return try req.content.decode(UpdatableUser.self).flatMap { newDetails in
				toUpdate.lastEvent = newDetails.lastEvent ?? authenticated.lastEvent
				
				return toUpdate.save(on: req).map { _ in
					return HTTPResponse(status: .noContent)
				}
			}
		}
	}
}
