//
//  ProfileViewController.swift
//  Lenta
//
//  Created by Alex on 27.01.2021.
//

import UIKit

protocol ProfileViewInput: AnyObject {
    func showMessage(_ message: String)
    func set(avatar: UIImage?)
    func showUserInfo(userModel: UserViewModel)
    func saveButton(isShow: Bool)
    func clearUserInfo()
    func activityIndicatorStop()
    func activityIndicatorStart()
}

final class ProfileViewController: UIViewController {

    // MARK: - Properties

    private lazy var navItem: UINavigationItem = {
        let navItem = UINavigationItem(title: "Profile")
        navItem.leftBarButtonItem = saveButton
        return navItem
    }()

    private lazy var navigationBar: UINavigationBar = {
        let navBar = UINavigationBar()
        navBar.barStyle = .default
        navBar.items = [navItem]
        navBar.isTranslucent = false
        navBar.translatesAutoresizingMaskIntoConstraints = false
        return navBar
    }()

    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "avatar")
        imageView.tintColor = Constants.Colors.active
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(imageTapGesture)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let textNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name:"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .thin)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.text = "----"
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.textColor = .black
        textField.addTarget(self, action: #selector(nameTextChange), for: .editingChanged)
        textField.accessibilityIdentifier = "nameTextField"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let textCountLabel: UILabel = {
        let label = UILabel()
        label.text = "Posts count:"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .thin)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let postsCountLabel: UILabel = {
        let label = UILabel()
        label.text = "--"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let textDateLabel: UILabel = {
        let label = UILabel()
        label.text = "Date register:"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .thin)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let dateRegisterLabel: UILabel = {
        let label = UILabel()
        label.text = "--.--.----"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
//        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()

    private lazy var imagePicker = ImagePicker(view: self, delegate: self)
    private lazy var saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self,
                                                  action: #selector(saveButtonPress))
    private lazy var imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
    private lazy var tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(heidKeyboard))

    var presenter: ProfileViewOutput?

    // MARK: - LiveCycles

    deinit {
        print("ProfileViewController deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        print("ProfileViewController init")
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        presenter?.start()
    }

    // MARK: - Methods

    @objc private func logInOutButtonPress() {
        presenter?.logInOutButtonPress()
    }

    @objc private func nameTextChange() {
        guard let name = nameTextField.text else { return }
        presenter?.change(name: name)
    }

    @objc private func saveButtonPress() {
        guard let name = nameTextField.text else { return }
        nameTextField.resignFirstResponder()
        presenter?.saveButtonPress(name: name, image: avatarImageView.image)
    }

    @objc private func heidKeyboard() {
        nameTextField.resignFirstResponder()
    }

    @objc private func chooseImage() {
        imagePicker.chooseImage()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        saveButton.isEnabled = false
        view.addGestureRecognizer(tapRecognizer)

        view.addSubview(navigationBar)
        view.addSubview(avatarImageView)
        view.addSubview(textNameLabel)
        view.addSubview(nameTextField)
        view.addSubview(textCountLabel)
        view.addSubview(postsCountLabel)
        view.addSubview(textDateLabel)
        view.addSubview(dateRegisterLabel)
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            avatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarImageView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 30),
            avatarImageView.widthAnchor.constraint(equalToConstant: 100),
            avatarImageView.heightAnchor.constraint(equalToConstant: 100),

            textNameLabel.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -10),
            textNameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 32),

            textCountLabel.trailingAnchor.constraint(equalTo: textNameLabel.trailingAnchor),
            textCountLabel.topAnchor.constraint(equalTo: textNameLabel.bottomAnchor, constant: 16),

            textDateLabel.trailingAnchor.constraint(equalTo: textNameLabel.trailingAnchor),
            textDateLabel.topAnchor.constraint(equalTo: textCountLabel.bottomAnchor, constant: 16),

            nameTextField.leadingAnchor.constraint(equalTo: textNameLabel.trailingAnchor, constant: 5),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16),
            nameTextField.firstBaselineAnchor.constraint(equalTo: textNameLabel.firstBaselineAnchor),

            postsCountLabel.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            postsCountLabel.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            postsCountLabel.firstBaselineAnchor.constraint(equalTo: textCountLabel.firstBaselineAnchor),

            dateRegisterLabel.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            dateRegisterLabel.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            dateRegisterLabel.firstBaselineAnchor.constraint(equalTo: textDateLabel.firstBaselineAnchor),

            activityIndicator.centerYAnchor.constraint(equalTo: navigationBar.centerYAnchor),
            activityIndicator.trailingAnchor.constraint(equalTo: navigationBar.leadingAnchor, constant: 80)
        ])

        avatarImageView.layer.cornerRadius = 50
        avatarImageView.clipsToBounds = true
    }
}

// MARK: - ProfileViewInput

extension ProfileViewController: ProfileViewInput {

    func showMessage(_ message: String) {
        let alertController = UIAlertController(title: "Profile", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

    func saveButton(isShow: Bool) {
        saveButton.isEnabled = isShow
    }

    func set(avatar: UIImage?) {
        avatarImageView.image = avatar
    }

    func showUserInfo(userModel: UserViewModel) {
        nameTextField.isEnabled = true
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.tintColor = Constants.Colors.active
        nameTextField.text = userModel.name
        nameTextField.textColor = Constants.Colors.active
        postsCountLabel.text = userModel.postsCount
        dateRegisterLabel.text = userModel.dateRegister
        let logoutBarButtonItem =
            UIBarButtonItem(image: UIImage(named: "logout"), style: .plain,
                            target: self, action: #selector(logInOutButtonPress))
        navItem.rightBarButtonItem = logoutBarButtonItem
        logoutBarButtonItem.accessibilityIdentifier = "loginoutBarButton"
    }

    func clearUserInfo() {
        nameTextField.isEnabled = false
        avatarImageView.isUserInteractionEnabled = false
        avatarImageView.image = UIImage(named: "avatar")
        avatarImageView.tintColor = Constants.Colors.deActive
        nameTextField.textColor = .black
        nameTextField.text = "----"
        postsCountLabel.text = "--"
        dateRegisterLabel.text = "--.--.----"
        let loginBarButtonItem =
            UIBarButtonItem(image: UIImage(named: "login"), style: .plain,
                            target: self, action: #selector(logInOutButtonPress))
        navItem.rightBarButtonItem = loginBarButtonItem
        loginBarButtonItem.accessibilityIdentifier = "loginoutBarButton"
    }

    func activityIndicatorStop() {
        activityIndicator.stopAnimating()
    }

    func activityIndicatorStart() {
        activityIndicator.startAnimating()
    }
}

// MARK: - ImagePickerDelegate

extension ProfileViewController: ImagePickerDelegate {

    func selectImage(_ image: UIImage) {
        self.avatarImageView.image = image
        presenter?.didSelectNewAvatar()
    }
}
