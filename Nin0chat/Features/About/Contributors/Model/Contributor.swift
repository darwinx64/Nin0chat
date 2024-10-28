//
//  Contributor.swift
//  Wcode
//
//  Created by tiramisu on 10/19/24.
//

/// src: https://github.com/CodeEditApp/CodeEdit/blob/main/CodeEdit/Features/About/Contributors/Model/Contributor.swift

import SwiftUI

struct ContributorsRoot: Codable {
    var contributors: [Contributor]
}

struct Contributor: Codable, Identifiable {
    var id: String { login }
    var login: String
    var name: String
    var avatarURLString: String
    var profile: String
    var description: String

    var avatarURL: URL? {
        URL(string: avatarURLString)
    }

    var gitHubURL: URL? {
        URL(string: "https://github.com/\(login)")
    }

    var profileURL: URL? {
        URL(string: profile)
    }

    enum CodingKeys: String, CodingKey {
        case login, name, profile, description
        case avatarURLString = "avatar_url"
    }
}
