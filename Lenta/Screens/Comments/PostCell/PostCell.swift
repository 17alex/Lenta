//
//  PostCell.swift
//  Lenta
//
//  Created by Alex on 11.03.2021.
//

import UIKit

class PostCell: UITableViewCell {
    
    //MARK: - IBOutlets:
    
    @IBOutlet weak var avatarImageView: WebImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var photoImageView: WebImageView!
    @IBOutlet weak var heightPhotoImageView: NSLayoutConstraint!
    @IBOutlet weak var fotoActivityIndicator: UIActivityIndicatorView!
    
    //MARK: - Variables
    
    private var postModel: PostViewModel! {
        didSet {
            userNameLabel.text = postModel.user.name
            setAvatar(by: postModel.user.avatarUrlString)
            timeLabel.text = postModel.time
            descriptionLabel.text = postModel.description.text
            setPostPhoto(by: postModel.photo.urlString)
            heightPhotoImageView.constant = postModel.photo.size.height
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.height / 2
        fotoActivityIndicator.hidesWhenStopped = true
    }

    //MARK: - Metods
        
    func set(postModel: PostViewModel) {
        self.postModel = postModel
    }
    
    // todo
    private func setPostPhoto(by urlString: String) {
        if urlString == "" { return }
        fotoActivityIndicator.startAnimating()
        photoImageView.load(by: urlString) {
            self.fotoActivityIndicator.stopAnimating()
        }
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
