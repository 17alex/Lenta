//
//  CommentCell.swift
//  Lenta
//
//  Created by Alex on 10.03.2021.
//

import UIKit

class CommentCell: UITableViewCell {

    //MARK: - IBOutlets:
    
    @IBOutlet weak var avatarImageView: WebImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var sameTextLabel: UILabel!
    
    //MARK: - Variables
    
    private var commentModel: CommentViewModel! {
        didSet {
            userNameLabel.text = commentModel.user.name
            dateLabel.text = commentModel.time
            sameTextLabel.text = commentModel.text
            setAvatar(by: commentModel.user.avatarUrlString)
        }
    }
    
    //MARK: - LiveCycles
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.height / 2
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        avatarImageView.image = nil
    }
    
    //MARK: - Metods
    
    func set(commentModel: CommentViewModel) {
        self.commentModel = commentModel
    }
    
    // todo
    private func setAvatar(by urlString: String) {
        if urlString != "" {
            avatarImageView.load(by: urlString) { }
        } else {
            avatarImageView.image = UIImage(named: "defaultAvatar")
        }
    }
}
