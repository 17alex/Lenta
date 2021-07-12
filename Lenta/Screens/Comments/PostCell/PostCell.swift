//
//  PostCell.swift
//  Lenta
//
//  Created by Alex on 11.03.2021.
//

import UIKit

final class PostCell: UITableViewCell {

    // MARK: - Pripertis

    static var reuseID: String {
        return self.description()
    }

    private let avatarImageView: WebImageView = {
        let imageView = WebImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.text = "userNameLabel"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.text = "timeLabel"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.text = "descriptionLabel"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let photoImageView: WebImageView = {
        let imageView = WebImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let fotoActivityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()

    private var photoImageViewHeight: NSLayoutConstraint?
    private let photoImageViewDefaultHeight: CGFloat = 0

    private var postModel: PostViewModel? {
        didSet {
            guard let postModel = postModel else { return }
            userNameLabel.text = postModel.user?.name ?? "NoName"
            setAvatar(by: postModel.user?.avatarUrlString ?? "")
            timeLabel.text = postModel.time
            descriptionLabel.text = postModel.description.text
            setPostPhoto(by: postModel.photo?.urlString)
            photoImageViewHeight?.constant = postModel.photo?.size.height ?? 0
        }
    }

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Metods

    func set(postModel: PostViewModel) {
        self.postModel = postModel
    }

    private func setPostPhoto(by urlString: String?) {
        guard let urlString = urlString else { return }
        fotoActivityIndicator.startAnimating()
        photoImageView.load(by: urlString) {
            self.fotoActivityIndicator.stopAnimating()
        }
    }

    private func setAvatar(by urlString: String) {
        if !urlString.isEmpty {
            avatarImageView.load(by: urlString)
        } else {
            avatarImageView.image = UIImage(named: "defaultAvatar")
        }
    }

    private func setupUI() {

        contentView.addSubview(avatarImageView)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(photoImageView)
        contentView.addSubview(fotoActivityIndicator)

        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            avatarImageView.widthAnchor.constraint(equalToConstant: 60),
            avatarImageView.heightAnchor.constraint(equalToConstant: 60),

            userNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            userNameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor, constant: 8),
            userNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            timeLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 32),
            timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            timeLabel.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: -8),

            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: photoImageView.topAnchor, constant: 0),

            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            photoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),

            fotoActivityIndicator.centerXAnchor.constraint(equalTo: photoImageView.centerXAnchor),
            fotoActivityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])

        photoImageViewHeight = photoImageView.heightAnchor.constraint(equalToConstant: photoImageViewDefaultHeight)
        photoImageViewHeight?.isActive = true
    }
}
