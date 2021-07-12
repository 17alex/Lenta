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

struct ResponseComment: Decodable {
    let posts: [Post]
    let comments: [Comment]
    let users: [User]
}

struct Comment: Decodable {
    let id: Int
    let timeInterval: TimeInterval
    let postId: Int
    let userId: Int
    let text: String
}

struct Post: Decodable {
    let id: Int16
    let userId: Int16
    let timeInterval: TimeInterval
    let description: String
    let photo: PostPhoto?
    let likeUserIds: [Int16]
    let viewsCount: Int16
    let commentsCount: Int16
}

struct PostPhoto: Decodable {
    let name: String
    let size: Size
}

struct Size: Decodable {
    let width: Int16
    let height: Int16
}

struct User: Codable, Hashable {
    let id: Int16
    let name: String
    let postsCount: Int16
    let dateRegister: TimeInterval
    let avatar: String
}
