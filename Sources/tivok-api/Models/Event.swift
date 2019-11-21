//
//  Event.swift
//
//
//  Created by Philipp Heller on 21.11.19.
//
import Vapor
import FluentPostgreSQL

final class Event: Content {
	var id: UUID?
	var name: String
	var startDate: TimeInterval?
	var endDate: TimeInterval?
	var location: String?
	var description: String?
	let ownerID: User.ID
	var published: Bool
	
	init(id: UUID? = nil,
		 owner: User,
		 name: String,
		 startDate: TimeInterval? = nil,
		 endDate: TimeInterval? = nil,
		 location: String? = nil,
		 description: String? = nil,
		 published: Bool = false
	) throws {
		self.id = id
		self.name = name
		self.startDate = startDate
		self.endDate = endDate
		self.location = location
		self.description = description
		self.ownerID = try owner.requireID()
		self.published = published
	}
}

extension Event: PostgreSQLUUIDModel {}

extension Event: PostgreSQLMigration {}

extension Event: Parameter {}

extension Event {
	var owner: Parent<Event, User> {
		return parent(\.ownerID)
	}
}
