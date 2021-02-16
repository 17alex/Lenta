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
    let id: Int
    let userId: Int
    let timeInterval: TimeInterval
    let description: String
    let foto: PostFoto
    let likeUserIds: [Int]
    let viewsCount: Int
    let commentsCount: Int
//    var isCompactDescription = true
}

struct PostFoto: Decodable {
    let name: String
    let size: FotoSize
}

struct FotoSize: Decodable {
    let width: Int
    let height: Int
}

struct User: Decodable, Hashable {
    let id: Int
    let name: String
    let avatar: String
}

