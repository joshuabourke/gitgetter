//
//  GitHubUserRepos.swift
//  JumboInteractiveTestApp
//
//  Created by Josh Bourke on 16/10/2024.
//

import Foundation



struct GitHubUserRepos: GitHubRepoProtocol {
    let name: String
    let description: String?
    let htmlUrl: String
    let language: String?
    let stargazersCount: Int?
    let watchers: Int?
    
    var repoHtmlUrl: String {htmlUrl}
}
