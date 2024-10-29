//
//  GitHubFollowersModel.swift
//  JumboInteractiveTestApp
//
//  Created by Josh Bourke on 16/10/2024.
//

import Foundation

struct GitHubFollowersModel: Codable, Hashable {
    let login: String
    let avatarUrl: String
    let url: String
}
