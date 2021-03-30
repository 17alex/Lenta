//
//  UserInfoViewController.swift
//  Lenta
//
//  Created by Alex on 25.03.2021.
//

import UIKit

final class UserInfoViewController: UIViewController {

    //MARK: - Propertis
    
    let avatarImageView: WebImageView = {
        let imageView = WebImageView()
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
        navItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeButtonPress))
        navBar.items = [navItem]
        navBar.translatesAutoresizingMaskIntoConstraints = false
        return navBar
    }()
    
    var user: UserViewModel?
    
    //MARK: - LiveCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        set(user: user)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.width / 2
        avatarImageView.clipsToBounds = true
    }
    
    //MARK: - Metods
    
    private func set(user: UserViewModel?) {
        userNameLabel.text = user?.name
        userPostCountLabel.text = user?.postCount
        userDateRegisterLabel.text = user?.dateRegister
        if let avatarUrl = user?.avatarUrlString {
            avatarImageView.load(by: avatarUrl) { }
        }
    }
    
    @objc
    private func closeButtonPress() {
        dismiss(animated: true)
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
        
        navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        avatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        avatarImageView.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 30).isActive = true
        avatarImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 20).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -15).isActive = true
        
        countLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20).isActive = true
        countLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor).isActive = true
        
        registerLabel.topAnchor.constraint(equalTo: countLabel.bottomAnchor, constant: 20).isActive = true
        registerLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor).isActive = true
        
        userNameLabel.firstBaselineAnchor.constraint(equalTo: nameLabel.firstBaselineAnchor).isActive = true
        userNameLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 10).isActive = true
        
        userPostCountLabel.firstBaselineAnchor.constraint(equalTo: countLabel.firstBaselineAnchor).isActive = true
        userPostCountLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor).isActive = true
        
        userDateRegisterLabel.firstBaselineAnchor.constraint(equalTo: registerLabel.firstBaselineAnchor).isActive = true
        userDateRegisterLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor).isActive = true
    }
}
