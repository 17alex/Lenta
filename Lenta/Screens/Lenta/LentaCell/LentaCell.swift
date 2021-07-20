//
//  LentaCell.swift
//  Lenta
//
//  Created by Alex on 11.01.2021.
//

import UIKit

protocol PostCellDelegate: AnyObject {
    func didTapLikeButton(cell: UITableViewCell)
    func didTapMenuButton(cell: UITableViewCell)
    func didTapCommentsButton(cell: UITableViewCell)
    func didTapShareButton(cell: UITableViewCell, with object: [Any])
    func didTapAvatar(cell: UITableViewCell)
}

final class LentaCell: UITableViewCell {
    
    // MARK: - Properties
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapAvatar)))
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var photoActivityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    private lazy var likesButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .systemGray
        button.addTarget(self, action: #selector(likesButtonPress), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var likesCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var eyeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "eye")
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var viewsCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var commentsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "bubble.right"), for: .normal)
        button.tintColor = .systemGray
        button.addTarget(self, action: #selector(commentsButtonPress), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var commentsCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrowshape.turn.up.right"), for: .normal)
        button.tintColor = .systemGray
        button.addTarget(self, action: #selector(shareButtonPress), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var menuButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "text.justify"), for: .normal)
        button.tintColor = .systemGray
        button.addTarget(self, action: #selector(menuButtonPress), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var likeStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [likesButton, likesCountLabel])
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var viewsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [eyeImageView, viewsCountLabel])
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var commentsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [commentsButton, commentsCountLabel])
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [likeStackView, viewsStackView, commentsStackView, shareButton])
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var photoImageViewRatio: NSLayoutConstraint?
    //    private var photoImageViewHeight: NSLayoutConstraint?
    
    private var postModel: PostViewModel? {
        didSet {
            guard let postModel = postModel else { return }
            userNameLabel.text = postModel.user?.name ?? "NoName"
            let newAvatarUrlString = postModel.user?.avatarUrlString ?? ""
            if avatarUrlString != newAvatarUrlString {
                avatarImageView.image = nil
            }
            avatarUrlString = newAvatarUrlString
            timeLabel.text = postModel.time
            descriptionLabel.text = postModel.description.text
            paintLikeButton(isHighlight: postModel.likes.isHighlight)
            likesCountLabel.text = postModel.likes.count
            viewsCountLabel.text = postModel.views.count
            commentsCountLabel.text = postModel.comments.count
            print("postModel.photo = ", postModel.photo)
            guard let newPhoto = postModel.photo else {
                photoImageView.image = nil
                photoActivityIndicator.stopAnimating()
                //                photoImageViewHeight?.isActive = false
                //                photoImageViewHeight?.constant = 0
                //                photoImageViewRatio?.constant = 0
                //                photoImageViewRatio?.isActive = false
                print("---- NIL-1")
                photoImageViewRatio?.isActive = false
                print("---- NIL-2")
                photoImageViewRatio = photoImageView.heightAnchor.constraint(equalTo: photoImageView.widthAnchor, multiplier: 0.001, constant: 0)
                print("---- NIL-3")
                photoImageViewRatio?.isActive = true
                print("---- NIL-4")
                //                photoImageView.setNeedsLayout()
                //                photoImageView.layoutIfNeeded()
                //                photoImageViewHeight?.isActive = true
                return
            }
            
            if photoUrlString != newPhoto.urlString {
                photoImageView.image = nil
                photoActivityIndicator.startAnimating()
                //                photoImageViewHeight?.isActive = false
                //                photoImageViewHeight?.constant = newPhoto.size.height
                //                photoImageViewHeight?.isActive = true
                //                photoImageViewRatio?.constant = newPhoto.ratio
                //                photoImageViewRatio?.isActive = false
//                if let photoImageViewRatio = photoImageViewRatio { NSLayoutConstraint.deactivate([photoImageViewRatio]) }
                print("-- noNIL-1 photoImageViewRatio =", photoImageViewRatio)

                photoImageViewRatio?.isActive = false
                //                photoImageViewRatio?.multiplier = 1
                print("-- noNIL-2 photoImageViewRatio =", photoImageViewRatio)
//                photoImageViewRatio = photoImageView.heightAnchor.constraint(equalTo: photoImageView.widthAnchor, multiplier: newPhoto.ratio, constant: 0)
                photoImageViewRatio = NSLayoutConstraint(item: photoImageView, attribute: .height, relatedBy: .equal, toItem: photoImageView, attribute: .width, multiplier: newPhoto.ratio, constant: 0)
                print("-- noNIL-3 photoImageViewRatio =", photoImageViewRatio)
                photoImageViewRatio?.isActive = true
                print("-- noNIL-4 photoImageViewRatio =", photoImageViewRatio)
                //                photoImageView.setNeedsLayout()
                //                photoImageView.layoutIfNeeded()
                photoUrlString = newPhoto.urlString
                
            }
        }
    }
    
    private var photoUrlString: String = ""
    private var avatarUrlString: String = ""
    
    weak var delegate: PostCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setNeedsUpdateConstraints() {
        super.setNeedsUpdateConstraints()
        print("setNeedsUpdateConstraints")
        
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        print("updateConstraints")
    }
    
    override func updateConstraintsIfNeeded() {
        super.updateConstraintsIfNeeded()
        print("updateConstraintsIfNeeded")
    }
    
    // MARK: - LiveCycles
    
    //    override func didMoveToSuperview() {
    //        super.didMoveToSuperview()
    //
    //        setupUI()
    //    }
    
    //    override func layoutSubviews() {
    //        super.layoutSubviews()
    //
    //        guard let postModel = postModel else { return }
    //        contentView.frame = CGRect(x: 0, y: 4, width: contentView.bounds.width, height: postModel.totalHieght - 8)
    //        let cellWidth = contentView.bounds.width
    //        avatarImageView.frame = CGRect(x: 8, y: 16, width: 60, height: 60)
    //        avatarImageView.layer.cornerRadius = avatarImageView.bounds.height / 2
    //        menuButton.frame = CGRect(x: cellWidth - 65, y: 18, width: 60, height: 60)
    //        userNameLabel.frame = CGRect(x: 79, y: 23, width: menuButton.frame.minX - 79, height: 24)
    //        timeLabel.frame = CGRect(x: 87, y: 53, width: menuButton.frame.minX - 87, height: 15)
    //        descriptionLabel.frame = CGRect(x: 8, y: 81, width: cellWidth - 16, height: postModel.description.size.height)
    //        let descrMaxY = descriptionLabel.frame.maxY
    //        photoImageView.frame = CGRect(x: 0, y: descrMaxY + 2, width: cellWidth,
    //                                      height: postModel.photo?.size.height ?? 0)
    //        photoActivityIndicator.center = photoImageView.center
    //        let buttonsY = photoImageView.frame.maxY + 2
    //        let offset: CGFloat = 25
    //        let space = (cellWidth - 80) / 3
    //        likesButton.frame = CGRect(x: offset, y: buttonsY, width: 30, height: 35)
    //        likesCountLabel.frame = CGRect(x: likesButton.frame.maxX, y: buttonsY, width: 30, height: 35)
    //        eyeImageView.frame = CGRect(x: offset + space, y: buttonsY, width: 30, height: 35)
    //        viewsCountLabel.frame = CGRect(x: eyeImageView.frame.maxX, y: buttonsY, width: 50, height: 35)
    //        commentsButton.frame = CGRect(x: offset + space * 2, y: buttonsY, width: 30, height: 35)
    //        commentsCountLabel.frame = CGRect(x: commentsButton.frame.maxX, y: buttonsY, width: 50, height: 35)
    //        shareButton.frame = CGRect(x: offset + space * 3, y: buttonsY, width: 30, height: 35)
    //    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            
            avatarImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 8),
            avatarImageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            avatarImageView.widthAnchor.constraint(equalToConstant: 60),
            avatarImageView.heightAnchor.constraint(equalToConstant: 60),
            
            menuButton.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 18),
            menuButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -5),
            menuButton.widthAnchor.constraint(equalToConstant: 60),
            menuButton.heightAnchor.constraint(equalToConstant: 60),
            
            userNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 11),
            userNameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor, constant: 7),
            userNameLabel.trailingAnchor.constraint(equalTo: menuButton.leadingAnchor, constant: 0),
            //            userNameLabel.heightAnchor.constraint(equalToConstant: 24),
            
            timeLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 19),
            timeLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 6),
            timeLabel.trailingAnchor.constraint(equalTo: menuButton.leadingAnchor, constant: 0),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 8),
            descriptionLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 5),
            descriptionLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -8),
            
            photoImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 0),
            photoImageView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 0),
            photoImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: 0),
            
            photoActivityIndicator.centerXAnchor.constraint(equalTo: photoImageView.centerXAnchor),
            photoActivityIndicator.centerYAnchor.constraint(equalTo: photoImageView.centerYAnchor),
            
            bottomStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 25),
            bottomStackView.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 2),
            bottomStackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -25),
            bottomStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -8),
            bottomStackView.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        avatarImageView.layer.cornerRadius = 30
//        photoImageViewRatio = photoImageView.widthAnchor.constraint(equalTo: photoImageView.heightAnchor, multiplier: 0, constant: 0)
        //        photoImageViewRatio?.constant = 0
        //        photoImageViewRatio?.multi
//        photoImageViewRatio?.isActive = true
        //        photoImageViewHeight = photoImageView.heightAnchor.constraint(equalToConstant: 256)
        //        photoImageViewHeight?.constant = 250
        //        photoImageViewHeight?.isActive = true
    }
    
    // MARK: - PublicMethods
    
    func likeUpdate(post: PostViewModel) {
        likesCountLabel.text = post.likes.count
        paintLikeButton(isHighlight: post.likes.isHighlight)
    }
    
    func set(postModel: PostViewModel) {
        self.postModel = postModel
    }
    
    func set(photo: UIImage?) {
        photoActivityIndicator.stopAnimating()
        //        print("setPhoto in cell")
        photoImageView.image = photo
    }
    
    func set(avatar: UIImage?) {
        //        print("setAvatar in cell")
        avatarImageView.image = avatar
    }
    
    // MARK: - PrivateMethods
    
    //    private func getPhotoHeight(photoViewModel: PhotoViewModel, width: CGFloat) -> CGFloat {
    //        return CGFloat(photoViewModel.size.height) / CGFloat(photoViewModel.size.width) * width
    //    }
    
    //    private func getDescriptionSize(text: String, width: CGFloat) -> CGSize {
    //        let maxDescriptionSize = CGSize(width: width, height: .greatestFiniteMagnitude)
    //        return descriptionLabel.sizeThatFits(maxDescriptionSize)
    //    }
    
    private func paintLikeButton(isHighlight: Bool) {
        likesButton.tintColor = isHighlight ? .systemRed : .systemGray
        let likeImage = isHighlight ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        likesButton.setImage(likeImage, for: .normal)
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
        if let text = descriptionLabel.text, !text.isEmpty { sendObjects.append(text) }
        if let image = photoImageView.image { sendObjects.append(image) }
        delegate?.didTapShareButton(cell: self, with: sendObjects)
    }
    
    @objc private func menuButtonPress() {
        delegate?.didTapMenuButton(cell: self)
    }
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = Constants.Colors.bgTable
        
        contentView.addSubview(cardView)
        cardView.addSubview(avatarImageView)
        cardView.addSubview(userNameLabel)
        cardView.addSubview(timeLabel)
        cardView.addSubview(menuButton)
        cardView.addSubview(descriptionLabel)
        cardView.addSubview(photoImageView)
        cardView.addSubview(likesButton)
        cardView.addSubview(likesCountLabel)
        cardView.addSubview(eyeImageView)
        cardView.addSubview(viewsCountLabel)
        cardView.addSubview(commentsButton)
        cardView.addSubview(commentsCountLabel)
        cardView.addSubview(shareButton)
        cardView.addSubview(photoActivityIndicator)
        cardView.addSubview(bottomStackView)
        
        setupConstraints()
    }
}
