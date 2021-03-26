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
    func didTapCommentsButton(cell: UITableViewCell)
    func didTapShareButton(cell: UITableViewCell, with object: [Any])
    func didTapAvatar(cell: UITableViewCell)
}

final class LentaCell: UITableViewCell {

    //MARK: - IBOutlets:

    @IBOutlet weak var avatarImageView: WebImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var photoImageView: WebImageView!
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var photoActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var viewsCountLabel: UILabel!
    @IBOutlet weak var commentsCountLabel: UILabel!
    @IBOutlet weak var likesButton: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var menuButton: UIButton!
    
    //MARK: - Variables
    
    private var postModel: PostViewModel! {
        didSet {
            userNameLabel.text = postModel.user.name
            setAvatar(by: postModel.user.avatarUrlString)
            timeLabel.text = postModel.time
            descriptionLabel.text = postModel.description.text
            paintLikeButton(isHighlight: postModel.likes.isHighlight)
            likesCountLabel.text = postModel.likes.count
            viewsCountLabel.text = postModel.views.count
            commentsCountLabel.text = postModel.comments.count
            setPostPhoto(by: postModel.photo.urlString)
        }
    }
    
    weak var delegate: PostCellDelegate?
    
    //MARK: - LiveCycles
    
    override func awakeFromNib() {
        super.awakeFromNib()
        photoActivityIndicator.hidesWhenStopped = true
        avatarImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapAvatar)))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        avatarImageView.image = nil
        photoImageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let cellWidth = contentView.bounds.width
        topView.frame = CGRect(x: 0, y: 0, width: cellWidth, height: 4)
        avatarImageView.frame = CGRect(x: 8, y: 16, width: 60, height: 60)
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.height / 2
        userNameLabel.frame.origin = CGPoint(x: 79, y: 23)
        timeLabel.frame.origin = CGPoint(x: 87, y: 53)
        menuButton.frame = CGRect(x: cellWidth - 65, y: 18, width: 60, height: 60)
        descriptionLabel.frame.origin = CGPoint(x: 8, y: 81)
        descriptionLabel.frame.size = CGSize(width: cellWidth - 16, height: postModel.description.size.height)
        let descrMaxY = descriptionLabel.frame.maxY
        photoImageView.frame = CGRect(x: 0, y: descrMaxY + 2, width: cellWidth, height: postModel.photo.size.height)
        photoActivityIndicator.center = photoImageView.center
        let photoMaxY = photoImageView.frame.maxY
        bottomStackView.frame = CGRect(x: 16, y: photoMaxY, width: cellWidth - 16 - 16, height: 40)
        let botStackMaxY = bottomStackView.frame.maxY
        bottomView.frame = CGRect(x: 0, y: botStackMaxY, width: cellWidth, height: 4)
    }
           
    //MARK: - PublicMetods
    
    func likeUpdate(post: PostViewModel) {
        likesCountLabel.text = post.likes.count
        paintLikeButton(isHighlight: post.likes.isHighlight)
    }
    
    func set(postModel: PostViewModel) {
        self.postModel = postModel
    }
    
    //MARK: - PrivateMetods
    
    @objc
    private func didTapAvatar() {
        print("didTapAvatar")
        delegate?.didTapAvatar(cell: self)
    }
    
    private func getPhotoHeight(photoViewModel: PhotoViewModel, width: CGFloat) -> CGFloat {
        return CGFloat(photoViewModel.size.height) / CGFloat(photoViewModel.size.width) * width
    }
    
    private func getDescriptionSize(text: String, width: CGFloat) -> CGSize {
        let maxDescriptionSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        return descriptionLabel.sizeThatFits(maxDescriptionSize)
    }
    
    private func paintLikeButton(isHighlight: Bool) {
        likesButton.tintColor = isHighlight ? .systemRed : .systemGray
    }
    
    // todo
    private func setPostPhoto(by urlString: String) {
        if urlString == "" { return }
        photoActivityIndicator.startAnimating()
        photoImageView.load(by: urlString) {
            self.photoActivityIndicator.stopAnimating()
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
    
    //MARK: - IBActions
    
    @IBAction func likesButtonPress() {
        print("likesButtonPress")
        delegate?.didTapLikeButton(cell: self)
    }
    
    @IBAction func munuButtonPress() {
        delegate?.didTapMenuButton(cell: self)
    }
    
    @IBAction func shareButtonPress(_ sender: UIButton) {
        print("share post")
        var sendObjects: [Any] = []
//        if let text = descriptionLabel.text { sendObjects.append(text) }
        if let image = photoImageView.image { sendObjects.append(image) }
        delegate?.didTapShareButton(cell: self, with: sendObjects)
    }
    
    @IBAction func commentsButtonPress(_ sender: UIButton) {
        delegate?.didTapCommentsButton(cell: self)
    }
}
