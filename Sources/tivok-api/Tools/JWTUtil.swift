//
//  JWTUtil.swift
//
//
//  Created by Philipp Heller on 04.11.19.
//

import JWT

class JWTUtil {
	private let jsonDecoder = JSONDecoder()
	
	/// Verifies JWK-signed OpenID compliant JWTs
	func verify(_ token: String) throws -> User.TokenPayload {
		let payload = try jsonDecoder.decode(
			User.TokenPayload.self,
			from: decodeBase64URL(token.components(separatedBy: ".")[1], encoding: .ascii)
		)
		
		// TODO: Check for right tenant instead of just using issuer..anyone could issue tokens that way
		let openIDConfiguration = try decodeJSONFromURL(payload.iss+".well-known/openid-configuration", to: OpenIDConfiguration.self)
		
		let jwks = try decodeJSONFromURL(openIDConfiguration.jwks_uri, to: JWKS.self)
		
		let jwt = try JWT<User.TokenPayload>(from: token, verifiedUsing: .init(jwks: jwks))
		
		return jwt.payload
	}
	
	private func decodeBase64URL(_ encoded: String, encoding: String.Encoding) throws -> String {
		var encoded = encoded
		
		// bring to right length
		let dividableLength = 4
		let encodedLength = encoded.count
		let rem = (encodedLength % dividableLength)
		
		if(rem != 0) {
			let mustLength = encodedLength + dividableLength - rem
		
			encoded = encoded.padding(toLength: mustLength, withPad: "=", startingAt: 0)
		}
		
		// Change Encoding from base64URL to base64
		encoded = encoded.replacingOccurrences(of: "-", with: "+")
		encoded = encoded.replacingOccurrences(of: "_", with: "/")
		
		// Actually decode
		guard let decodedData = Data(base64Encoded: encoded),
			let decoded = String(data: decodedData, encoding: encoding) else {
			throw DecodingError(message: "Could not decode Base64")
		}
		return decoded
	}
	
	private func decodeJSONFromURL<D: Decodable>(_ url: String, to type: D.Type) throws -> D {
		guard let url = URL(string: url) else {
			throw URLError(URLError.badURL)
		}
		
		return try decodeJSONFromURL(url, to: D.self)
	}
	
	private func decodeJSONFromURL<D: Decodable>(_ url: URL, to type: D.Type) throws -> D {
		let jsonString = try String(contentsOf: url)
		return try jsonDecoder.decode(D.self, from: jsonString)
	}
	
	private struct OpenIDConfiguration: Decodable {
		let jwks_uri: URL
	}
	
	private struct DecodingError: Error {
		let message: String
	}
}
