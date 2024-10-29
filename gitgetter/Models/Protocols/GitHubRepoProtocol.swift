//
//  GitHubRepoProtocol.swift
//  JumboInteractiveTestApp
//
//  Created by Josh Bourke on 18/10/2024.
//

import Foundation

//This is a set of rules for other struct items to abide by
protocol GitHubRepoProtocol: Codable, Hashable {
    var name: String {get}
    var description: String? {get}
//    var htmlUrl: String {get}
    var language: String? {get}
    var stargazersCount: Int? {get}
    var watchers: Int? {get}
    
    var repoHtmlUrl: String {get}
}

extension GitHubRepoProtocol {
    var repoHtmlUrl: String {
        return ""
    }
}
