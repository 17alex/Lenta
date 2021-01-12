//
//  LentaCell.swift
//  Lenta
//
//  Created by Alex on 11.01.2021.
//

import UIKit

class LentaCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 10
    }

    func set(post: PostViewModel) {
        titleLabel.text = post.title
        nameLabel.text = post.name
        descriptionLabel.text = post.description
        
        let maxLabelWidth = contentView.bounds.width - 16 - 16
        let maxLabelSize = CGSize(width: maxLabelWidth, height: .greatestFiniteMagnitude)
        
        let titleLabelOrigin = CGPoint(x: 16, y: 16)
        let titleLabelSize = titleLabel.sizeThatFits(maxLabelSize)
        titleLabel.frame = CGRect(origin: titleLabelOrigin, size: titleLabelSize)
        
        let descriptionLabelSize = descriptionLabel.sizeThatFits(maxLabelSize)
        let descriptionLabelOrigin = CGPoint(x: 16, y: contentView.bounds.height - 16 - descriptionLabelSize.height)
        descriptionLabel.frame = CGRect(origin: descriptionLabelOrigin, size: descriptionLabelSize)
        
        let nameLabelSize = nameLabel.sizeThatFits(maxLabelSize)
        let nameLabelOrigin = CGPoint(x: 16, y: descriptionLabel.frame.minY - nameLabelSize.height - 8)
        nameLabel.frame = CGRect(origin: nameLabelOrigin, size: nameLabelSize)
    }
}
