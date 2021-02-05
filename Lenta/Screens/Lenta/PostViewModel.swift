//
//  PostViewModel.swift
//  Lenta
//
//  Created by Alex on 11.01.2021.
//

import Foundation

struct PostViewModel {
    let id: Int
    let avatarImageName: String
    let userName: String
    let time: String
    let description: String
    let postImageName: String
    let postImageWidth: Int
    let postImageHeight: Int
    var likesCount: String
    let viewsCount: String
    let commentsCount: String
    var likesIsHighlight: Bool
    var numberOfLineDescription = 3
    
    init(post: Post, user: User) {
        id = post.postId
        avatarImageName = user.avatarName
        userName = user.name
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        
        let postTimeInterval = post.timeInterval
        let nowDate = Date()
        let nowDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: nowDate)
        let startNowDate = Calendar.current.date(from: nowDateComponents)
        let startNowDayTimeInterval = startNowDate!.timeIntervalSince1970
        var dateString = ""
        let secondsPerDay: Double = 24 * 60 * 60
        dateFormatter.dateFormat = "HH:mm "
        if postTimeInterval - startNowDayTimeInterval > 0 {
            dateString = "  today"
        } else if postTimeInterval - startNowDayTimeInterval + secondsPerDay > 0 {
            dateString = "  yesterday"
        } else {
            dateString = ""
            dateFormatter.dateFormat = "HH:mm  d MMMM yyyy"
        }
        
        time = dateFormatter.string(from: Date(timeIntervalSince1970: post.timeInterval)) + dateString
        
        description = post.description
        postImageName = post.postImage.imageName
        likesCount = String(post.likesIds.count)
        viewsCount = String(post.viewsCount)
        commentsCount = String(post.commentsCount)
        postImageWidth = post.postImage.imageSize.height
        postImageHeight = post.postImage.imageSize.width
        likesIsHighlight = post.likesIds.contains(post.userId)
    }
    
    mutating func update(with post: Post) {
        likesCount = String(post.likesIds.count)
        likesIsHighlight = post.likesIds.contains(post.userId)
    }
}
