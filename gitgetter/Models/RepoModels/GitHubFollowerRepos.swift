//
//  GitHubFollowerRepos.swift
//  JumboInteractiveTestApp
//
//  Created by Josh Bourke on 18/10/2024.
//

import Foundation

struct GitHubFollowerRepos: GitHubRepoProtocol {
    let name: String
    let description: String?
    let owner: GitHubFollowerOwner
    let language: String?
    let stargazersCount: Int?
    let watchers: Int?
    
    var repoHtmlUrl: String {owner.htmlUrl}
}

struct GitHubFollowerOwner: Codable, Hashable {
    let htmlUrl: String
}
