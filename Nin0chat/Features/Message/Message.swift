//
//  Message.swift
//  Nin0chat
//
//  Created by tiramisu on 10/22/24.
//

struct Message: Hashable {
    var author: User
    var content: String
    var type: Int
}
