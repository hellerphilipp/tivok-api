//
//  User.swift
//  Basic User Model to work with Auth0
//
//  Created by Philipp Heller on 03.11.19.
//

import Vapor
import FluentPostgreSQL
import Authentication

final class User: Content {
	var id: UUID?
	var sub: String
	var email: String
	var emailVerified: Bool
	var givenName: String
	var familyName: String
	var pictureURL: URL?
	
	init(id: UUID? = nil,
		 sub: String,
		 email: String,
		 emailVerified: Bool = false,
		 givenName: String,
		 familyName: String,
		 pictureURL: URL?
	) {
		self.id = id
		self.sub = sub
		self.email = email
		self.emailVerified = emailVerified
		self.givenName = givenName
		self.familyName = familyName
		self.pictureURL = pictureURL
	}
}

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
