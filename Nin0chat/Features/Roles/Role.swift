//
//  RoleModel.swift
//  Nin0chat
//
//  Created by tiramisu on 10/22/24.
//

struct Role {
    
    /// These users do not have persistent user IDs. They are capped to 300 characters.
    static let Guest: Int = 1 << 0
    
    /// Normal users
    static let User: Int = 1 << 1
    
    /// These users are bots
    static let Bot: Int = 1 << 2
    
    /// These are system messages sent by the nin0chat backend
    static let System: Int = 1 << 3
    
    /// These users will have moderation permissions over the backend
    static let Mod: Int = 1 << 4
    
    /// Reserved to nin0, this role has extra powers over staff members
    static let Admin: Int = 1 << 5
}
