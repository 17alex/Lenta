//
//  LentaCell.swift
//  Lenta
//
//  Created by Alex on 11.01.2021.
//

import UIKit

protocol CellDelegate: class {
    func didTabMoreButton(cell: UITableViewCell)
    func didTabLikeButton(cell: UITableViewCell)
}

final class LentaCell: UITableViewCell {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var fotoImageView: UIImageView!
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var fotoActivityIndicator: UIActivityIndicatorView! {
        didSet {
            fotoActivityIndicator.hidesWhenStopped = true
        }
    }
    @IBOutlet weak var topMoreButton: NSLayoutConstraint!
    @IBOutlet weak var heightFotoImageView: NSLayoutConstraint!
//    @IBOutlet weak var heightMoreButton: NSLayoutConstraint!
    //    @IBOutlet weak var heightDescriptionLabel: NSLayoutConstraint!
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var viewsCountLabel: UILabel!
    @IBOutlet weak var commentsCountLabel: UILabel!
    @IBOutlet weak var likesButton: UIButton!
    
    var logoImageViewUrl: URL!
    var fotoImageViewUrl: URL!
    var imHeight: CGFloat = 0
    
    weak var delegate: CellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        logoImageView.layer.cornerRadius = 30
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        fotoImageView.image = nil
        topMoreButton.constant = 0
        moreButton.isHidden = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        print("LentaCell - layoutSubviews: self.bouns = \(self.bounds)")
    }
    
    func smallUpdate(post: PostViewModel) {
        likesCountLabel.text = post.likesCount
        likesButton.tintColor = post.likesIsHighlight ? .systemRed : .systemGray2
    }
    
    func set(post: PostViewModel) {
        userNameLabel.text = post.userName + " postId = \(post.id)"
        setAvatar(avatarName: post.avatarImageName)
        timeLabel.text = post.time
        descriptionLabel.numberOfLines = post.numberOfLineDescription
        if post.numberOfLineDescription == 0 {
            topMoreButton.constant = -26
            moreButton.isHidden = true
        }
        descriptionLabel.text = post.description
        likesButton.tintColor = post.likesIsHighlight ? .systemRed : .systemGray2
        likesCountLabel.text = post.likesCount
        viewsCountLabel.text = post.viewsCount
        commentsCountLabel.text = post.commentsCount
        imHeight = calculateImageHeight(imageWidth: post.postImageWidth, imageHeight: post.postImageHeight)
        print("post.id=\(post.id); Width=\(post.postImageWidth); Height=\(post.postImageHeight); bounds.width=\(UIScreen.main.bounds.width); imHeight=\(imHeight)")
        heightFotoImageView.constant = imHeight
        setPostImage(postImageName: post.postImageName)
    }
    
    private func setPostImage(postImageName: String) {
        if postImageName != "", let url = URL(string: "https://monsterok.ru/lenta/images/\(postImageName)") {
            fotoActivityIndicator.startAnimating()
            fotoImageViewUrl = url
            loadImage(for: url) { (image, imageUrl) in
                if self.fotoImageViewUrl.absoluteString == imageUrl.absoluteString {
                    self.fotoActivityIndicator.stopAnimating()
                    self.fotoImageView.image = image
                }
            }
        }
    }
    
    private func setAvatar(avatarName: String) {
        if avatarName != "", let url = URL(string: "https://monsterok.ru/lenta/avatars/\(avatarName)") {
            logoImageViewUrl = url
            loadImage(for: url) { (image, imageUrl) in
                if self.logoImageViewUrl.absoluteString == imageUrl.absoluteString {
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
        return widthSizeFotoImageView / CGFloat(imageRatio)
    }
    
    //TODO: todo
    private func loadImage(for url: URL, complete: @escaping (UIImage, URL) -> Void) {
        let urlRequest = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)
        URLSession.shared.dataTask(with: urlRequest) { (data, _, _) in
            if let data = data, let loadImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    complete(loadImage, url)
                }
            }
        }.resume()
    }
    
    @IBAction func likesButtonPress() {
        delegate?.didTabLikeButton(cell: self)
    }
    
    @IBAction func moreButtonPress() {
        delegate?.didTabMoreButton(cell: self)
    }
}


//        let maxDescriptionWidth = userNameLabel.frame.maxX - logoImageView.frame.minX
//        print("maxDescriptionWidth = \(maxDescriptionWidth)")
//        let maxDescriptionSize = CGSize(width: maxDescriptionWidth, height: .greatestFiniteMagnitude)
//        let descriptionLabelSize = descriptionLabel.sizeThatFits(maxDescriptionSize)
//        descriptionLabel.frame.origin = CGPoint(x: logoImageView.frame.minX, y: logoImageView.frame.maxY + 8)
//        descriptionLabel.frame.size = descriptionLabelSize
//
//        moreButton.frame.origin = CGPoint(x: descriptionLabel.frame.minX, y: descriptionLabel.frame.maxY + 10)
//        moreButton.frame.size = CGSize(width: maxDescriptionWidth, height: 20)
//
//        fotoImageView.frame.origin = CGPoint(x: 0, y: moreButton.frame.maxY + 16)
//        fotoImageView.frame.size = CGSize(width: bounds.width, height: imHeight)
//
//        bottomStackView.frame.origin = CGPoint(x: descriptionLabel.frame.minX, y: fotoImageView.frame.maxY + 16)
//        bottomStackView.frame.size = CGSize(width: maxDescriptionWidth, height: 36)
