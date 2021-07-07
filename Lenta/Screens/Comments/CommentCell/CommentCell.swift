//
//  CommentCell.swift
//  Lenta
//
//  Created by Alex on 10.03.2021.
//

import UIKit

final class CommentCell: UITableViewCell {

    //MARK: - Propertis
    
    static var reuseID: String {
        return self.description()
    }
    
    private let avatarImageView: WebImageView = {
        let imageView = WebImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.text = "userNameLabel"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .light)
        label.text = "dateLabel"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.text = "commentLabel"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var commentModel: CommentViewModel? {
        didSet {
            guard let commentModel = commentModel else { return }
            userNameLabel.text = commentModel.user?.name ?? "NoName"
            dateLabel.text = commentModel.time
            commentLabel.text = commentModel.text
            setAvatar(by: commentModel.user?.avatarUrlString ?? "")
        }
    }
    
    //MARK: - Init
    //FIXME: - metod Constrains
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - LiveCycles
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        avatarImageView.image = nil
    }
    
    //MARK: - Metods
    
    func set(commentModel: CommentViewModel) {
        self.commentModel = commentModel
    }
    
    // FIXME: -
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
        contentView.addSubview(dateLabel)
        contentView.addSubview(commentLabel)
        
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            avatarImageView.widthAnchor.constraint(equalToConstant: 40),
            avatarImageView.heightAnchor.constraint(equalToConstant: 40),
            
            userNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            userNameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor, constant: 0),
            userNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            dateLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 32),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            dateLabel.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 0),
            
            commentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            commentLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
            commentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            commentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }
}
