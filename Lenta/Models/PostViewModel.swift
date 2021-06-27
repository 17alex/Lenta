//
//  PostViewModel.swift
//  Lenta
//
//  Created by Alex on 11.01.2021.
//

import UIKit

struct UserViewModel {
    let id: Int16 //FIXME: - надо ли ?
    let name: String
    let avatarUrlString: String
    let postsCount: String
    let dateRegister: String
    
    init(user: User) {
        self.id = user.id
        self.name = user.name
        self.avatarUrlString = user.avatar == "" ? "" : Constants.URLs.avatarsPath + user.avatar
        self.postsCount = String(user.postsCount)
        self.dateRegister = user.dateRegister.toDateString()
    }
    
    init?(user: User?) {
        guard let unwrapUser = user else { return nil }
        self.id = unwrapUser.id
        self.name = unwrapUser.name
        self.avatarUrlString = unwrapUser.avatar.isEmpty ? "" : Constants.URLs.avatarsPath + unwrapUser.avatar
        self.postsCount = String(unwrapUser.postsCount)
        self.dateRegister = unwrapUser.dateRegister.toDateString()
    }
}

struct PhotoViewModel {
    let urlString: String
    let size: CGSize
}

struct PostViewModel {
    let id: Int16
    let time: String
    let user: UserViewModel
    var description: DescriptionViewModel
    var photo: PhotoViewModel?
    var likes: LikesViewModel
    let views: ViewsViewModel
    let comments: CommentsViewModel
    var totalHieght: CGFloat
    
    struct DescriptionViewModel {
        let text: String
        var size: CGSize
        var isExpand: Bool = false
    }

    struct LikesViewModel {
        var count: String
        var isHighlight: Bool
    }
    
    struct ViewsViewModel {
        let count: String
    }
    
    struct CommentsViewModel { //TODO: - todo
        let count: String
    }
    
    init(post: Post, user: User, currenUser: User?) {
        self.id = post.id
        self.user = UserViewModel(user: user)
        self.time = post.timeInterval.toDateString()
        self.description = DescriptionViewModel(text: post.description, size: .zero)
        
        var photoHeight: CGFloat = 0
        if let postPhoto = post.photo, !postPhoto.name.isEmpty {
            let postPhotoUrlSting = "https://monsterok.ru/lenta/images/" + postPhoto.name
            photoHeight = CGFloat(postPhoto.size.height) / CGFloat(postPhoto.size.width) * UIScreen.main.bounds.width //FIXME: - del UIScreen
            self.photo = PhotoViewModel(
                urlString: postPhotoUrlSting,
                size: CGSize(
                    width: UIScreen.main.bounds.width,
                    height: photoHeight)
            )
        }
        
        self.likes = LikesViewModel(
            count: String(post.likeUserIds.count),
            isHighlight: post.likeUserIds.contains(currenUser?.id ?? -1)
        )
        
        self.views = ViewsViewModel(count: String(post.viewsCount))
        self.comments = CommentsViewModel(count: String(post.commentsCount))
        //FIXME: - height descrip = 0
        let textSize = CGSize(width: UIScreen.main.bounds.width - 16, height: .greatestFiniteMagnitude)
        let rect = post.description.boundingRect(with: textSize,
                                     options: .usesLineFragmentOrigin,
                                     attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15)],
                                     context: nil)
        self.description.size = CGSize(width: rect.width, height: rect.height)
        
        self.totalHieght = 81 + description.size.height + 2 + photoHeight + 40 + 4
    }
    
    mutating func update(with post: Post) {
        likes.count = String(post.likeUserIds.count)
        likes.isHighlight = post.likeUserIds.contains(post.userId)
    }
}

