//
//  UserModel.swift
//  Nin0chat
//
//  Created by tiramisu on 10/22/24.
//

import SwiftUI

struct User: Hashable {
    var username: String
    var id: String
    var roles: Int? = Role.Guest
}
