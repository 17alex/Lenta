//
//  PostViewModel.swift
//  Lenta
//
//  Created by Alex on 11.01.2021.
//

import UIKit

struct UserViewModel {
    let id: Int16
    let name: String
    let avatarUrlString: String
    let postsCount: String
    let dateRegister: String

    init?(user: User?) {
        guard let user = user else { return nil }
        id = user.id
        name = user.name
        avatarUrlString = user.avatar.isEmpty ? "" : Constants.URLs.avatarsPath + user.avatar
        postsCount = String(user.postsCount)
        dateRegister = user.dateRegister.toDateString()
    }
}

struct PhotoViewModel {
    let urlString: String
    let ratio: CGFloat
}

struct PostViewModel {
    let id: Int16
    let time: String
    let user: UserViewModel?
    var description: DescriptionViewModel
    var photo: PhotoViewModel?
    var likes: LikesViewModel
    let views: ViewsViewModel
    let comments: CommentsViewModel
//    var totalHieght: CGFloat

    struct DescriptionViewModel {
        let text: String
//        var size: CGSize
    }

    struct LikesViewModel {
        var count: String
        var isHighlight: Bool
    }

    struct ViewsViewModel {
        let count: String
    }

    struct CommentsViewModel {
        let count: String
    }

    init(post: Post, user: User?, currenUser: User? = nil) {
        self.id = post.id
        self.user = UserViewModel(user: user)
        self.time = post.timeInterval.toDateString()
        self.description = DescriptionViewModel(text: post.description)

//        var photoRatio: CGFloat = 0.001
        if let postPhoto = post.photo, !postPhoto.name.isEmpty {
            let postPhotoUrlSting = Constants.URLs.imagesPath + postPhoto.name
            let photoRatio = CGFloat(postPhoto.size.height) / CGFloat(postPhoto.size.width)
            self.photo = PhotoViewModel(urlString: postPhotoUrlSting, ratio: photoRatio)
        }

        self.likes = LikesViewModel(
            count: String(post.likeUserIds.count),
            isHighlight: post.likeUserIds.contains(currenUser?.id ?? -1)
        )

        self.views = ViewsViewModel(count: String(post.viewsCount))
        self.comments = CommentsViewModel(count: String(post.commentsCount))

//        let textSize = CGSize(width: UIScreen.main.bounds.width - 16, height: .greatestFiniteMagnitude)
//        let rect = post.description.boundingRect(with: textSize,
//                                     options: .usesLineFragmentOrigin,
//                                     attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)],
//                                     context: nil)
//        self.description.size = CGSize(width: rect.width, height: rect.height)

//        let postHeaderHeight: CGFloat = 81
//        let spaceHeight: CGFloat = 2
//        let postFooter: CGFloat = 40
//        self.totalHieght = postHeaderHeight + description.size.height
//            + spaceHeight + photoRatio + postFooter + spaceHeight * 2
    }

    mutating func update(with post: Post) {
        likes.count = String(post.likeUserIds.count)
        likes.isHighlight = post.likeUserIds.contains(post.userId)
    }
}
