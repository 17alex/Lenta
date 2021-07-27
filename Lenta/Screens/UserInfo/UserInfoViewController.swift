//
//  UserInfoViewController.swift
//  Lenta
//
//  Created by Alex on 25.03.2021.
//

import UIKit

protocol UserInfoViewInput: AnyObject {
    func set(user: UserViewModel?)
    func set(avatar: UIImage?)
}

final class UserInfoViewController: UIViewController {

    // MARK: - Properties

    let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "defaultAvatar")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .thin)
        label.text = "Name:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let countLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 15, weight: .thin)
        label.text = "Post count:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let registerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 15, weight: .thin)
        label.text = "Date register:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let userNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.text = "------"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let userPostCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.text = "--"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let userDateRegisterLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.text = "--.--.----"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let navBar: UINavigationBar = {
        let navBar = UINavigationBar()
        let navItem = UINavigationItem(title: "User info")
        navItem.rightBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeButtonPress))
        navBar.items = [navItem]
        navBar.translatesAutoresizingMaskIntoConstraints = false
        return navBar
    }()

    private var user: UserViewModel? {
        didSet {
            userNameLabel.text = user?.name
            userPostCountLabel.text = user?.postsCount
            userDateRegisterLabel.text = user?.dateRegister
        }
    }

    var presenter: UserInfoViewOutput?

    // MARK: - LifeCycles

    deinit {
        print("UserInfoViewController deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("UserInfoViewController init")
        setupUI()
        presenter?.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        avatarImageView.layer.cornerRadius = avatarImageView.bounds.width / 2
        avatarImageView.clipsToBounds = true
    }

    // MARK: - Methods

    @objc private func closeButtonPress() {
        presenter?.closeButtonPress()
    }

    private func setupUI() {

        view.backgroundColor = .systemBackground

        view.addSubview(avatarImageView)
        view.addSubview(nameLabel)
        view.addSubview(countLabel)
        view.addSubview(registerLabel)
        view.addSubview(userNameLabel)
        view.addSubview(userPostCountLabel)
        view.addSubview(userDateRegisterLabel)
        view.addSubview(navBar)

        NSLayoutConstraint.activate([

            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            avatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarImageView.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 30),
            avatarImageView.widthAnchor.constraint(equalToConstant: 100),
            avatarImageView.heightAnchor.constraint(equalToConstant: 100),

            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -15),

            countLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            countLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),

            registerLabel.topAnchor.constraint(equalTo: countLabel.bottomAnchor, constant: 20),
            registerLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),

            userNameLabel.firstBaselineAnchor.constraint(equalTo: nameLabel.firstBaselineAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 10),

            userPostCountLabel.firstBaselineAnchor.constraint(equalTo: countLabel.firstBaselineAnchor),
            userPostCountLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor),

            userDateRegisterLabel.firstBaselineAnchor.constraint(equalTo: registerLabel.firstBaselineAnchor),
            userDateRegisterLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor)
        ])
    }
}

// MARK: - UserInfoViewInput

extension UserInfoViewController: UserInfoViewInput {

    func set(user: UserViewModel?) {
        self.user = user
    }

    func set(avatar: UIImage?) {
        avatarImageView.image = avatar
    }
}
