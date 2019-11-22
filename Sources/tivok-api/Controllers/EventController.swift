//
//  EventController.swift
//
//  Created by Philipp Heller on 21.11.19.
//

import Vapor

class EventController: RouteCollection {
	func boot(router: Router) throws {
		let protected = router.grouped(JWTMiddleware()) // TODO: Make JWTMiddleware a service
		protected.post("events", use: createEvent)
		protected.get("events", use: getEvents)
		protected.get("events", Event.parameter, use: getHandler)
	}
	
	func createEvent(req: Request) throws -> Future<HTTPResponse> {
		let user = try req.requireAuthenticated(User.self)
		
		return try req.content.decode(EventNameStruct.self).flatMap { eventData in
			let event = try Event(owner: user, name: eventData.name)
			
			return event.save(on: req).map { event in
				let httpResponse = try HTTPResponse(status: .created, headers: ["Location": "/events/\(event.requireID())"])
				
				return httpResponse
			}
		}
	}
	
	// FIXME: return all events here, and have extra ?filter for user w/ permissions
	// or should this only return events where user has read access anyway?
	func getEvents(req: Request) throws -> Future<[Event]> {
		let user = try req.requireAuthenticated(User.self)
		
		return try user.events.query(on: req).all()
	}
	
	func getHandler(_ req: Request) throws -> Future<Event> {
		return try req.parameters.next(Event.self)
	}
	
	private struct EventNameStruct: Decodable {
		let name: String
	}
}
