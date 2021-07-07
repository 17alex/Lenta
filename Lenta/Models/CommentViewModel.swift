//
//  CommentViewModel.swift
//  Lenta
//
//  Created by Alex on 10.03.2021.
//

import Foundation

struct CommentViewModel {
    let id: Int
    let time: String
    let user: UserViewModel?
    let text: String
    
    init(comment: Comment, user: User?) {
        self.id = comment.id
        self.time = comment.timeInterval.toDateString()
        self.user = UserViewModel(user: user)
        self.text = comment.text
    }
}
