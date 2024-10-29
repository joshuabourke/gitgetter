//
//  GitHubUserModel.swift
//  JumboInteractiveTestApp
//
//  Created by Josh Bourke on 16/10/2024.
//

import Foundation

struct GitHubUserModel: Codable {
    let login: String
    let avatarUrl: String
    let bio: String
}
