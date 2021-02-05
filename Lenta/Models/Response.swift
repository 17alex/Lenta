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
    let postImage: PostImage
    let likesIds: [Int]
    let viewsCount: Int
    let commentsCount: Int
}

struct PostImage: Decodable {
    let imageName: String
    let imageSize: ImageSize
}

struct ImageSize: Decodable {
    let width: Int
    let height: Int
}

struct User: Decodable {
    let id: Int
    let name: String
    let avatarName: String
}

struct Resp: Decodable {
    let users: [User]
}
