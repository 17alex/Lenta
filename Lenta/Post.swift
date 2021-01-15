//
//  Post.swift
//  Lenta
//
//  Created by Alex on 11.01.2021.
//

import Foundation

struct Post: Codable {
    let postId: Int
    let userId: Int
    let timeInterval: TimeInterval
    let description: String?
    let imageName: String?
}
