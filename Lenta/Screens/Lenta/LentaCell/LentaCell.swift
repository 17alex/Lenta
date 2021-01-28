//
//  LentaCell.swift
//  Lenta
//
//  Created by Alex on 11.01.2021.
//

import UIKit

class LentaCell: UITableViewCell {

    @IBOutlet weak var logoImageView: WebImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var fotoImageView: WebImageView!
    @IBOutlet weak var heightFotoImageView: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        logoImageView.layer.cornerRadius = 30
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        fotoImageView.image = nil
    }
    
    func set(post: PostViewModel) {
        userNameLabel.text = post.userName
        setAvatar(avatarName: post.avatarImageName)
        timeLabel.text = post.time
        descriptionLabel.text = post.description
        let imHeight: CGFloat = calculateImageHeight(imageWidth: post.postImageWidth, imageHeight: post.postImageHeight)
        print("post.id=\(post.id); Width=\(post.postImageWidth); Height=\(post.postImageHeight); bounds.width=\(UIScreen.main.bounds.width); imHeight=\(imHeight)")
        heightFotoImageView.constant = imHeight
        setPostImage(postImageName: post.postImageName)
//        layoutIfNeeded()
    }
    
    private func setPostImage(postImageName: String) {
        if postImageName != "", let url = URL(string: "https://monsterok.ru/lenta/images/\(postImageName)") {
            fotoImageView.loadImage(for: url) { (image, imageUrl) in
                if url.absoluteString == imageUrl.absoluteString {
                    self.fotoImageView.image = image
                }
            }
        }
    }
    
    private func setAvatar(avatarName: String) {
        if avatarName != "", let url = URL(string: "https://monsterok.ru/lenta/avatars/\(avatarName)") {
            logoImageView.loadImage(for: url) { (image, imageUrl) in
                if url.absoluteString == imageUrl.absoluteString {
                    self.logoImageView.image = image
                }
            }
        } else {
            logoImageView.image = UIImage(named: "defaultAvatar")
        }
    }
    
    private func calculateImageHeight(imageWidth: Int, imageHeight: Int) -> CGFloat {
        let imageRatio = CGFloat(imageWidth) / CGFloat(imageHeight)
        let widthSizeFotoImageView = UIScreen.main.bounds.width
        return widthSizeFotoImageView * CGFloat(imageRatio)
    }
}
