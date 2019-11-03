//
//  routes.swift
//  Manages all the incoming Routes
//
//  Created by Philipp Heller on 31.10.19.
//

import Vapor

func routes(_ router: Router) throws {
	let userRoutes = UserController()
	try router.register(collection: userRoutes)
}
