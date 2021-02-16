//
//  PostViewModel.swift
//  Lenta
//
//  Created by Alex on 11.01.2021.
//

import UIKit

struct PostViewModel {
    let id: Int
    var time: String
    let user: UserViewModel
    var description: DescriptionViewModel
    let foto: FotoViewModel
    var likes: LikesViewModel
    let views: ViewsViewModel
    let comments: CommentsViewModel
    var totalHieght: CGFloat
    
    struct FotoViewModel {
        let name: String
        let size: CGSize
    }
    
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
    
    struct CommentsViewModel {
        let count: String
    }
    
    struct UserViewModel {
        let id: Int
        let name: String
        let avatar: String
    }
    
    init(post: Post, user: User, currenUser: CurrentUser?) {
        self.id = post.id
        self.user = UserViewModel(
            id: user.id,
            name: user.name,
            avatar: user.avatar
        )
        self.time = post.timeInterval.toDateString()
        self.description = DescriptionViewModel(text: post.description, size: .zero)
        self.foto = FotoViewModel(name: post.foto.name, size: CGSize(width: UIScreen.main.bounds.width, height: CGFloat(post.foto.size.height) / CGFloat(post.foto.size.width) * UIScreen.main.bounds.width)
        )
        self.likes = LikesViewModel(
            count: String(post.likeUserIds.count),
            isHighlight: post.likeUserIds.contains(currenUser?.id ?? -1)
        )
        self.views = ViewsViewModel(count: String(post.viewsCount))
        self.comments = CommentsViewModel(count: String(post.commentsCount))
        totalHieght = 0
        
        let textSize = CGSize(width: UIScreen.main.bounds.width - 16, height: .greatestFiniteMagnitude)
        let rect = post.description.boundingRect(with: textSize,
                                     options: .usesLineFragmentOrigin,
                                     attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15)],
                                     context: nil)
        self.description.size = CGSize(width: rect.width, height: rect.height)
        
        self.totalHieght = 8 + 60 + 5 + description.size.height + 16 + foto.size.height + 16 + 40 + 16
    }
    
    mutating func update(with post: Post) {
        likes.count = String(post.likeUserIds.count)
        likes.isHighlight = post.likeUserIds.contains(post.userId)
    }
}
