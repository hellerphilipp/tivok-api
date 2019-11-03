//
//  User.swift
//  Basic User Model to work with Auth0
//
//  Created by Philipp Heller on 03.11.19.
//

import Vapor
import FluentPostgreSQL

final class User: Content {
	var id: UUID?
	var email: String
	var firstname: String
	var lastname: String
	
	init(id: UUID? = nil, email: String, firstname: String, lastname: String) {
		self.id = id
		self.email = email
		self.firstname = firstname
		self.lastname = lastname
	}
}

extension User: PostgreSQLUUIDModel {}

// Make email a unique property
extension User: PostgreSQLMigration {
	static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        return PostgreSQLDatabase.create(self, on: connection) { builder in
            try addProperties(to: builder)

            builder.unique(on: \.email)
        }
    }
}

extension User: Parameter {}
