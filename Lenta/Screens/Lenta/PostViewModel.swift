//
//  PostViewModel.swift
//  Lenta
//
//  Created by Alex on 11.01.2021.
//

import Foundation

struct PostViewModel {
    let avatarImageName: String
    let userName: String
    let time: String
    let description: String
    let postImageName: String
    
    init(post: Post, user: User) {
        avatarImageName = user.logoName
        userName = user.name
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "HH:mm  d MMMM yyyy"
        time = dateFormatter.string(from: Date(timeIntervalSince1970: post.timeInterval))
        
        description = post.description
        postImageName = post.imageName
    }
}
