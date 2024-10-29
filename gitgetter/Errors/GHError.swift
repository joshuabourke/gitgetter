//
//  GitHubUserModelError.swift
//  JumboInteractiveTestApp
//
//  Created by Josh Bourke on 16/10/2024.
//

import Foundation

enum GHError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case rateLimitExceeded // 403
    case notFound // 404
    case serverError //500
    case unknownError(statusCode: Int)
}

func handleErrorGHError(_ error: Error, context: String) {
    if let ghError = error as? GHError {
        switch ghError {
        case .invalidURL:
            print("Invalid \(context) URL")
        case .invalidResponse:
            print("Invalid \(context) Data")
        case .invalidData:
            print("Invalid \(context) response")
        case .rateLimitExceeded:
            print("Github Rate limit exceeded \(context)")
        case .notFound:
            print("\(context) endpoint not found")
        case .serverError:
            print("\(context) endpoint server error")
        case .unknownError(let statusCode):
            print("Unexpected \(context) error with status code: \(statusCode)")
        }
    } else {
        print("Unexpected \(context) Error: \(error)")
    }
}
