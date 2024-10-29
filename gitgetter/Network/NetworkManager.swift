//
//  NetworkManager.swift
//  JumboInteractiveTestApp
//
//  Created by Josh Bourke on 16/10/2024.
//

import Foundation

struct NetworkManager {
    
    func getUser(username: String) async throws -> GitHubUserModel {
        let endpoint = "https://api.github.com/users/\(username)"
        
        guard let url = URL(string: endpoint) else {
            throw GHError.invalidURL }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse else {
            throw GHError.invalidResponse
        }
        
        try validateResponseStatusCode(response)
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(GitHubUserModel.self, from: data)
        } catch {
            throw GHError.invalidData
        }
    }
    
    func getUserFollowers(username: String) async throws -> [GitHubFollowersModel] {
        let endpoint = "https://api.github.com/users/\(username)/followers"
        
        guard let url = URL(string: endpoint) else {
            throw GHError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse else {
            throw GHError.invalidResponse
        }
        
        try validateResponseStatusCode(response)
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            return try decoder.decode([GitHubFollowersModel].self, from: data)
        } catch {
            throw GHError.invalidData
        }
    }
    
    func getFollowerAccountDetails(followerEndPoint: String) async throws -> GitHubFollowerAccountModel {
        
        guard let url = URL(string: followerEndPoint) else {
            throw  GHError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse else {
            throw GHError.invalidData
        }
        
        try validateResponseStatusCode(response)
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(GitHubFollowerAccountModel.self, from: data)
        } catch {
            throw GHError.invalidData
        }
    }
    
    func getRepoList<T: GitHubRepoProtocol> (username: String) async throws -> [T] {
        let endpoint = "https://api.github.com/users/\(username)/repos"
        
        guard let url = URL(string: endpoint) else {
            throw GHError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse else {
            throw GHError.invalidData
        }
        
        try validateResponseStatusCode(response)
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode([T].self, from: data)
        } catch {
            throw GHError.invalidData
        }
    }
        
    //This is a function that is going to handle responses good and bad.
    func validateResponseStatusCode(_ response: HTTPURLResponse) throws {
        switch response.statusCode {
        case 200: //Everything is ok!
            break
        case 403:
            throw GHError.rateLimitExceeded //403
        case 404:
            throw GHError.notFound //404
        case 500:
            throw GHError.serverError //500
        default:
            throw GHError.unknownError(statusCode: response.statusCode)
        }
    }
    
}
