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
    let id: Int
    let userId: Int
    let timeInterval: TimeInterval
    let description: String
    let photo: PostPhoto?
    let likeUserIds: [Int]
    let viewsCount: Int
    let commentsCount: Int
}

struct PostPhoto: Decodable {
    let name: String
    let size: PhotoSize
}

struct PhotoSize: Decodable {
    let width: Int
    let height: Int
}

struct User: Decodable, Hashable {
    let id: Int
    let name: String
    let postsCount: Int
    let dateRegister: TimeInterval
    let avatar: String
}

