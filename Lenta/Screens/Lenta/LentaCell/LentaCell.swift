//
//  LentaCell.swift
//  Lenta
//
//  Created by Alex on 11.01.2021.
//

import UIKit

protocol PostCellDelegate: class {
    func didTapLikeButton(cell: UITableViewCell)
    func didTapMenuButton(cell: UITableViewCell)
}

final class LentaCell: UITableViewCell {

    //MARK: - IBOutlets:
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var fotoImageView: UIImageView!
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var fotoActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var viewsCountLabel: UILabel!
    @IBOutlet weak var commentsCountLabel: UILabel!
    @IBOutlet weak var likesButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var heightFoto: NSLayoutConstraint!
    
    //MARK: - Variables
    
    private var postModel: PostViewModel! {
        didSet {
            userNameLabel.text = postModel.user.name + "  postId = \(postModel.id)"
            setAvatar(avatarName: postModel.user.avatar)
            timeLabel.text = postModel.time
            descriptionLabel.text = postModel.description.text
            paintLikeButton(isHighlight: postModel.likes.isHighlight)
            likesCountLabel.text = postModel.likes.count
            viewsCountLabel.text = postModel.views.count
            commentsCountLabel.text = postModel.comments.count
            setPostImage(postImageName: postModel.foto.name)
            heightFoto.constant = postModel.foto.size.height
        }
    }
    
    var logoImageViewUrl: URL!
    var fotoImageViewUrl: URL!
    var imHeight: CGFloat = 0
    
    weak var delegate: PostCellDelegate?
    
    //MARK: - LiveCycles
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("awakeFromNib contentView.frame = \(contentView.frame)")
        avatarImageView.layer.cornerRadius = 30
    }
           
    //MARK: - PublicMetods
    
    func smallUpdate(post: PostViewModel) {
        likesCountLabel.text = post.likes.count
        paintLikeButton(isHighlight: post.likes.isHighlight)
    }
    
    func set(postModel: PostViewModel) {
        self.postModel = postModel
    }
    
    //MARK: - PrivateMetods
    
    private func paintLikeButton(isHighlight: Bool) {
        likesButton.tintColor = isHighlight ? .systemRed : .systemGray2
    }
    
    // todo
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
    
    // todo
    private func setAvatar(avatarName: String) {
        if avatarName != "", let url = URL(string: "https://monsterok.ru/lenta/avatars/\(avatarName)") {
            logoImageViewUrl = url
            loadImage(for: url) { (image, imageUrl) in
                if self.logoImageViewUrl.absoluteString == imageUrl.absoluteString {
                    self.avatarImageView.image = image
                }
            }
        } else {
            avatarImageView.image = UIImage(named: "defaultAvatar")
        }
    }
    
    // todo
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
    
    //MARK: - IBActions
    
    @IBAction func likesButtonPress() {
        delegate?.didTapLikeButton(cell: self)
    }
    
    @IBAction func munuButtoPress() {
        delegate?.didTapMenuButton(cell: self)
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
