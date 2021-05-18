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

    //MARK: - Propertis

    lazy private var avatarImageView: WebImageView = {
        let imageView = WebImageView()
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapAvatar)))
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        return label
    }()
    
    private var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        return label
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private var photoImageView: WebImageView = {
        let imageView = WebImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var photoActivityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    lazy private var likesButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .systemGray
        button.addTarget(self, action: #selector(likesButtonPress), for: .touchUpInside)
        return button
    }()
    
    private var likesCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = .systemGray
        return label
    }()
    
    private var eyeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "eye")
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var viewsCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = .systemGray
        return label
    }()
    
    lazy private var commentsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "bubble.right"), for: .normal)
        button.tintColor = .systemGray
        button.addTarget(self, action: #selector(commentsButtonPress), for: .touchUpInside)
        return button
    }()
    
    private var commentsCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = .systemGray
        return label
    }()
    
    lazy private var shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrowshape.turn.up.right"), for: .normal)
        button.tintColor = .systemGray
        button.addTarget(self, action: #selector(shareButtonPress), for: .touchUpInside)
        return button
    }()
    
    lazy private var menuButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "text.justify"), for: .normal)
        button.tintColor = .systemGray
        button.addTarget(self, action: #selector(menuButtonPress), for: .touchUpInside)
        return button
    }()
    
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
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = .init(x: 0, y: 4, width: contentView.bounds.width, height: postModel.totalHieght - 8)
        
        let cellWidth = contentView.bounds.width
        avatarImageView.frame = CGRect(x: 8, y: 16, width: 60, height: 60)
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.height / 2
        menuButton.frame = CGRect(x: cellWidth - 65, y: 18, width: 60, height: 60)
        userNameLabel.frame = CGRect(x: 79, y: 23, width: menuButton.frame.minX - 79, height: 24)
        timeLabel.frame = CGRect(x: 87, y: 53, width: menuButton.frame.minX - 87, height: 15)
        descriptionLabel.frame = .init(x: 8, y: 81, width: cellWidth - 16, height: postModel.description.size.height)
        let descrMaxY = descriptionLabel.frame.maxY
        photoImageView.frame = CGRect(x: 0, y: descrMaxY + 2, width: cellWidth, height: postModel.photo.size.height)
        photoActivityIndicator.center = photoImageView.center
        let photoMaxY = photoImageView.frame.maxY
        let offset: CGFloat = 25
        let space = (cellWidth - 80) / 3
        likesButton.frame = .init(x: offset, y: photoMaxY, width: 30, height: 35)
        likesCountLabel.frame = .init(x: likesButton.frame.maxX, y: photoMaxY, width: 30, height: 35)
        eyeImageView.frame = .init(x: offset + space, y: photoMaxY, width: 30, height: 35)
        viewsCountLabel.frame = .init(x: eyeImageView.frame.maxX, y: photoMaxY, width: 50, height: 35)
        commentsButton.frame = .init(x: offset + space * 2, y: photoMaxY, width: 30, height: 35)
        commentsCountLabel.frame = .init(x: commentsButton.frame.maxX, y: photoMaxY, width: 50, height: 35)
        shareButton.frame = .init(x: offset + space * 3, y: photoMaxY, width: 30, height: 35)
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
    
    private func getPhotoHeight(photoViewModel: PhotoViewModel, width: CGFloat) -> CGFloat {
        return CGFloat(photoViewModel.size.height) / CGFloat(photoViewModel.size.width) * width
    }
    
    private func getDescriptionSize(text: String, width: CGFloat) -> CGSize {
        let maxDescriptionSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        return descriptionLabel.sizeThatFits(maxDescriptionSize)
    }
    
    private func paintLikeButton(isHighlight: Bool) {
        likesButton.tintColor = isHighlight ? .systemRed : .systemGray
        let likeImage = isHighlight ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        likesButton.setImage(likeImage, for: .normal)
    }
    
    private func setPostPhoto(by urlString: String) {
        if urlString == "" { return }
        photoActivityIndicator.startAnimating()
        photoImageView.load(by: urlString) {
            self.photoActivityIndicator.stopAnimating()
        }
    }
    
    private func setAvatar(by urlString: String) {
        if urlString != "" {
            avatarImageView.load(by: urlString) { }
        } else {
            avatarImageView.image = UIImage(named: "defaultAvatar")
        }
    }
    
    @objc private func didTapAvatar() {
        print("didTapAvatar")
        delegate?.didTapAvatar(cell: self)
    }
    
    @objc private func likesButtonPress() {
        print("likesButtonPress")
        delegate?.didTapLikeButton(cell: self)
    }
    
    @objc private func commentsButtonPress(_ sender: UIButton) {
        print("commentsButtonPress")
        delegate?.didTapCommentsButton(cell: self)
    }
    
    @objc private func shareButtonPress(_ sender: UIButton) {
        print("share post")
        var sendObjects: [Any] = []
        if let image = photoImageView.image { sendObjects.append(image) }
        delegate?.didTapShareButton(cell: self, with: sendObjects)
    }
    
    @objc  func menuButtonPress() {
        delegate?.didTapMenuButton(cell: self)
    }
    
    private func setup() {

        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .white
        
//        let likeStackView = UIStackView(arrangedSubviews: [likesButton, likesCountLabel])
//        likeStackView.axis = .horizontal
//        likeStackView.alignment = .fill
//        likeStackView.distribution = .fillProportionally
//
//        let viewsStackView = UIStackView(arrangedSubviews: [eyeImageView, viewsCountLabel])
//        viewsStackView.axis = .horizontal
//        viewsStackView.alignment = .fill
//        viewsStackView.distribution = .fillProportionally
//
//        let commentsStackView = UIStackView(arrangedSubviews: [commentsButton, commentsCountLabel])
//        commentsStackView.axis = .horizontal
//        commentsStackView.alignment = .fill
//        commentsStackView.distribution = .fillProportionally
        
           
//        bottomStackView = UIStackView(arrangedSubviews: [likeStackView, viewsStackView, commentsStackView, shareButton])
//        bottomStackView.axis = .horizontal
//        bottomStackView.alignment = .fill
//        bottomStackView.distribution = .equalSpacing
           
        
//        bottomStackView.addArrangedSubview(likeStackView)
//        bottomStackView.addArrangedSubview(viewsStackView)
//        bottomStackView.addArrangedSubview(commentsStackView)
//        bottomStackView.addArrangedSubview(shareButton)
        
//        contentView.addSubview(topView)
        contentView.addSubview(avatarImageView)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(menuButton)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(photoImageView)
        contentView.addSubview(likesButton)
        contentView.addSubview(likesCountLabel)
        contentView.addSubview(eyeImageView)
        contentView.addSubview(viewsCountLabel)
        contentView.addSubview(commentsButton)
        contentView.addSubview(commentsCountLabel)
        contentView.addSubview(shareButton)
//        contentView.addSubview(bottomStackView)
//        contentView.addSubview(bottomView)
    }
}
