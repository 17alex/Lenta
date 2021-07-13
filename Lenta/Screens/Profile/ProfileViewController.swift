//
//  ProfileViewController.swift
//  Lenta
//
//  Created by Alex on 27.01.2021.
//

import UIKit

protocol ProfileViewInput: AnyObject {
    func userLoginned(_ currentUserModel: UserViewModel?)
    func didChangeProfile(_ change: Bool)
    func showMessage(_ message: String)
    func set(avatar: UIImage?)
}

final class ProfileViewController: UIViewController {

    // MARK: - Propertis

    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "avatar")
        imageView.tintColor = Constants.Colors.active
        imageView.isUserInteractionEnabled = true
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
        textField.textColor = Constants.Colors.active
        textField.addTarget(self, action: #selector(nameTextChange), for: .editingChanged)
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

    lazy private var imagePicker = ImagePicker(view: self, delegate: self)
    lazy private var saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self,
                                                  action: #selector(saveButtonPress))
    lazy private var imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
    lazy private var tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(heidKeyboard))

    var presenter: ProfileViewOutput?

    var currentUserModel: UserViewModel? {
        didSet {
            if let currentUserModel = currentUserModel {
                showUserInfo(userModel: currentUserModel)
            } else {
                clearUserInfo()
            }
        }
    }

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

    // MARK: - Metods

    @objc private func logInOutButtonPress() {
        presenter?.logInOutButtonPress()
    }

    @objc private func nameTextChange() {
        guard let name = nameTextField.text else { return }
        presenter?.change(name: name)
    }

    private func showUserInfo(userModel: UserViewModel) {
        nameTextField.isEnabled = true
        avatarImageView.isUserInteractionEnabled = true
        nameTextField.text = userModel.name
        nameTextField.textColor = Constants.Colors.active
        postsCountLabel.text = userModel.postsCount
        dateRegisterLabel.text = userModel.dateRegister
//        if userModel.avatarUrlString.isEmpty {
//            avatarImageView.image = UIImage(named: "avatar")
//            avatarImageView.tintColor = Constants.Colors.active
//        } else {
//            avatarImageView.load(by: userModel.avatarUrlString)
//        }
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(image: UIImage(named: "logout"), style: .plain,
                            target: self, action: #selector(logInOutButtonPress))
    }

    private func clearUserInfo() {
        nameTextField.isEnabled = false
        avatarImageView.isUserInteractionEnabled = false
        avatarImageView.image = UIImage(named: "avatar")
        avatarImageView.tintColor = Constants.Colors.deActive
        nameTextField.textColor = Constants.Colors.deActive
        nameTextField.text = "----"
        postsCountLabel.text = "--"
        dateRegisterLabel.text = "--.--.----"
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(image: UIImage(named: "login"), style: .plain,
                            target: self, action: #selector(logInOutButtonPress))
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
        navigationItem.leftBarButtonItem = saveButton
        avatarImageView.addGestureRecognizer(imageTapGesture)
        view.addGestureRecognizer(tapRecognizer)

        view.addSubview(avatarImageView)
        view.addSubview(textNameLabel)
        view.addSubview(nameTextField)
        view.addSubview(textCountLabel)
        view.addSubview(postsCountLabel)
        view.addSubview(textDateLabel)
        view.addSubview(dateRegisterLabel)

        NSLayoutConstraint.activate([

            avatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            avatarImageView.widthAnchor.constraint(equalToConstant: 100),
            avatarImageView.heightAnchor.constraint(equalToConstant: 100),

            textNameLabel.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -5),
            textNameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 32),

            textCountLabel.trailingAnchor.constraint(equalTo: textNameLabel.trailingAnchor),
            textCountLabel.topAnchor.constraint(equalTo: textNameLabel.bottomAnchor, constant: 16),

            textDateLabel.trailingAnchor.constraint(equalTo: textNameLabel.trailingAnchor),
            textDateLabel.topAnchor.constraint(equalTo: textCountLabel.bottomAnchor, constant: 16),

            nameTextField.leadingAnchor.constraint(equalTo: textNameLabel.trailingAnchor, constant: 10),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16),
            nameTextField.firstBaselineAnchor.constraint(equalTo: textNameLabel.firstBaselineAnchor),

            postsCountLabel.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            postsCountLabel.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            postsCountLabel.firstBaselineAnchor.constraint(equalTo: textCountLabel.firstBaselineAnchor),

            dateRegisterLabel.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            dateRegisterLabel.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            dateRegisterLabel.firstBaselineAnchor.constraint(equalTo: textDateLabel.firstBaselineAnchor)
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

    func didChangeProfile(_ change: Bool) {
        saveButton.isEnabled = change
    }

    func userLoginned(_ currentUserModel: UserViewModel?) {
        self.currentUserModel = currentUserModel
    }

    func set(avatar: UIImage?) {
        avatarImageView.image = avatar
    }
}

// MARK: - ImagePickerDelegate

extension ProfileViewController: ImagePickerDelegate {

    func selectImage(_ image: UIImage) {
        self.avatarImageView.image = image
        presenter?.didSelectNewAvatar()
    }
}
