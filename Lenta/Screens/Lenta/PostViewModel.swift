//
//  PostViewModel.swift
//  Lenta
//
//  Created by Alex on 11.01.2021.
//

import Foundation

struct PostViewModel {
    let title: String?
    let name: String?
    let description: String?
    let imageUrl: String?
    
    init(post: Post) {
        self.title = post.title
        self.name = post.name
        self.description = post.description
        self.imageUrl = post.imageUrl
    }
}
