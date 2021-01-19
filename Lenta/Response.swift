//
//  Post.swift
//  Lenta
//
//  Created by Alex on 11.01.2021.
//

import Foundation

struct Response: Decodable {
    let posts: [Post]
    let users: [User]
}

struct Post: Decodable {
    let postId: Int
    let userId: Int
    let timeInterval: TimeInterval
    let description: String
    let imageName: String
}

struct User: Decodable {
    let id: Int
    let name: String
    let logoName: String
}

struct Resp: Decodable {
    let users: [User]
}
