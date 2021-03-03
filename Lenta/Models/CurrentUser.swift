//
//  User.swift
//  Lenta
//
//  Created by Alex on 15.01.2021.
//

import Foundation

struct CurrentUser: Codable {
    let id: Int
    let name: String
    let postsCount: Int
    let dateRegister: TimeInterval
    let avatar: String
}
