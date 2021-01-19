//
//  LentaCell.swift
//  Lenta
//
//  Created by Alex on 11.01.2021.
//

import UIKit
import SDWebImage

class LentaCell: UITableViewCell {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var fotoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        logoImageView.layer.cornerRadius = 30
    }
    
    func set(post: PostViewModel) {
        let logoImageName = post.avatarImageName
        if logoImageName != "",
           let url = URL(string: "https://monsterok.ru/lenta/avatars/\(logoImageName)") {
            logoImageView.sd_setImage(with: url)
        }
        userNameLabel.text = post.userName
        timeLabel.text = post.time
        descriptionLabel.text = post.description
        let urlString = post.postImageName
        if urlString != "",
           let url = URL(string: "https://monsterok.ru/lenta/images/\(urlString)") {
            fotoImageView.sd_setImage(with: url)
        }
        
        //        let maxLabelWidth = contentView.bounds.width - 16 - 16
//        let maxLabelSize = CGSize(width: maxLabelWidth, height: .greatestFiniteMagnitude)
//
//        let titleLabelOrigin = CGPoint(x: 16, y: 16)
//        let titleLabelSize = titleLabel.sizeThatFits(maxLabelSize)
//        titleLabel.frame = CGRect(origin: titleLabelOrigin, size: titleLabelSize)
//
//        let descriptionLabelSize = descriptionLabel.sizeThatFits(maxLabelSize)
//        let descriptionLabelOrigin = CGPoint(x: 16, y: contentView.bounds.height - 16 - descriptionLabelSize.height)
//        descriptionLabel.frame = CGRect(origin: descriptionLabelOrigin, size: descriptionLabelSize)
//
//        let nameLabelSize = nameLabel.sizeThatFits(maxLabelSize)
//        let nameLabelOrigin = CGPoint(x: 16, y: descriptionLabel.frame.minY - nameLabelSize.height - 8)
//        nameLabel.frame = CGRect(origin: nameLabelOrigin, size: nameLabelSize)
    }
}
