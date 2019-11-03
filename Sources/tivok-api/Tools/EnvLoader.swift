//
//  EnvLoader.swift
//  Loads configuration from Env
//
//  Created by Philipp Heller on 03.11.19.
//

import Vapor

public class EnvLoader {
	public static func get(_ key: String) throws -> String {
		if let value = Environment.get(key) {
			return value
		}
		throw ConfigurationError.keyNotFound(key)
	}
	
	public static func getAsInt(_ key: String) throws -> Int {
		if let value = try Int(get(key)) {
			return value
		}
		throw ConfigurationError.typeMismatch(key)
	}

	public enum ConfigurationError: Error {
		case keyNotFound(_ key: String)
		case typeMismatch(_ key: String)
	}
}
