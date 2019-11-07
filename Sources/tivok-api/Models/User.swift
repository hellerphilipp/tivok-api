//
//  User.swift
//  Basic User Model to work with Auth0
//
//  Created by Philipp Heller on 03.11.19.
//

import Vapor
import FluentPostgreSQL
import Authentication

protocol UserData: Decodable {
	var id: UUID? { get set }
	var sub: String { get set }
	var email: String { get set }
	var emailVerified: Bool { get set }
	var givenName: String { get set }
	var familyName: String { get set }
	var pictureURL: URL? { get set }
}

final class User: UserData {
	var id: UUID?
	var sub: String
	var email: String
	var emailVerified: Bool
	var givenName: String
	var familyName: String
	var pictureURL: URL?
	
	init(id: UUID? = nil, sub: String, email: String, emailVerified: Bool, givenName: String, familyName: String, pictureURL: URL?) {
		self.id = id
		self.sub = sub
		self.email = email
		self.emailVerified = emailVerified
		self.givenName = givenName
		self.familyName = familyName
		self.pictureURL = pictureURL
	}
}

extension User: Content {}

extension User: PostgreSQLUUIDModel {}

// Make email a unique property
extension User: PostgreSQLMigration {
	static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        return PostgreSQLDatabase.create(self, on: connection) { builder in
            try addProperties(to: builder)

            builder.unique(on: \.sub)
			builder.unique(on: \.email)
        }
    }
}

extension User: Parameter {}

extension User: Authenticatable {}
