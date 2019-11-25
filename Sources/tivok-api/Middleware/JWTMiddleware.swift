//
//  JWTMiddleware.swift
//
//
//  Created by Philipp Heller on 04.11.19.
//

import Vapor
import FluentPostgreSQL

struct JWTMiddleware: Middleware {
	func respond(to req: Request, chainingTo next: Responder) throws -> Future<Response> {
		guard let token = req.http.headers.bearerAuthorization?.token,
			let payload = try? req.make(JWTUtil.self).verify(token) else {
			throw Abort(.unauthorized)
		}

		return User.query(on: req).filter(\User.sub == payload.sub).first().flatMap() { user in
			if let user = user {
				// Authenticate user if it exists
				try req.authenticate(user)
				return try next.respond(to: req)
			} else {
				// If user doesn't exist, create a new one and authenticate it
				// TODO: Check if Same Email Exists for custom error (will currently just fail)
				 return User(
					sub: payload.sub,
					email: payload.email,
					emailVerified: payload.emailVerified,
					givenName: payload.givenName,
					familyName: payload.familyName,
					pictureURL: payload.pictureURL
				).save(on: req).flatMap { user in
					try req.authenticate(user)
					return try next.respond(to: req)
				}
			}
		}
	}
}
