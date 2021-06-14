//
//  ProfileViewController.swift
//  Lenta
//
//  Created by Alex on 27.01.2021.
//

import UIKit

protocol ProfileViewInput: class {
    func userLoginned(_ currentUserModel: CurrentUserModel?)
    func didChangeProfile(_ change: Bool)
    func showMessage(_ message: String)
}

final class ProfileViewController: UIViewController {
     
    //MARK: - Propertis
    
    private let avatarImageView: WebImageView = {
        let imageView = WebImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "avatar")
        imageView.tintColor = #colorLiteral(red: 0.01894661598, green: 0.5350132585, blue: 1, alpha: 1)
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let textNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .thin)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.text = "----"
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.textColor = #colorLiteral(red: 0.01894661598, green: 0.5350132585, blue: 1, alpha: 1)
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
    
    lazy var imagePicker = ImagePicker(view: self, delegate: self)
    lazy var saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonPress))
    lazy var imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
    lazy var tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(heidKeyboard))
    
    var presenter: ProfileViewOutput!
    
    var currentUserModel: CurrentUserModel? {
        didSet {
            if let currentUserModel = currentUserModel {
                showUserInfo(userModel: currentUserModel)
            } else {
                clearUserInfo()
            }
        }
    }
    
    //MARK: - LiveCycles
    
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
        
        presenter.start()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.height / 2
        avatarImageView.clipsToBounds = true
    }
    
    //MARK: - Metods
    
    @objc private func logInOutButtonPress() {
        presenter.logInOutButtonPress()
    }
    
    @objc private func nameTextChange() {
        presenter.change(name: nameTextField.text!)
    }
    
    private func showUserInfo(userModel: CurrentUserModel) {
        nameTextField.isEnabled = true
        avatarImageView.isUserInteractionEnabled = true
        nameTextField.text = userModel.name
        postsCountLabel.text = userModel.postsCount
        dateRegisterLabel.text = userModel.dateRegister
        if userModel.avatar.isEmpty {
            avatarImageView.image = UIImage(named: "avatar")
            avatarImageView.tintColor = #colorLiteral(red: 0, green: 0.5138283968, blue: 1, alpha: 1)
        } else {
            avatarImageView.load(by: userModel.avatar) { }
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "logout"), style: .plain, target: self, action: #selector(logInOutButtonPress))
    }
    
    private func clearUserInfo() {
        nameTextField.isEnabled = false
        avatarImageView.isUserInteractionEnabled = false
        avatarImageView.image = UIImage(named: "avatar")
        avatarImageView.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        nameTextField.text = ""
        postsCountLabel.text = "--"
        dateRegisterLabel.text = "--.--.----"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "login"), style: .plain, target: self, action: #selector(logInOutButtonPress))
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
    }
    
    @objc func saveButtonPress() {
        nameTextField.resignFirstResponder()
        presenter.saveButtonPress(name: nameTextField.text!, image: avatarImageView.image)
    }
    
    @objc private func heidKeyboard() {
        nameTextField.resignFirstResponder()
    }
    
    @objc private func chooseImage() {
        imagePicker.chooseImage()
    }
}

//MARK: - ProfileViewInput

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
    
    func userLoginned(_ currentUserModel: CurrentUserModel?) {
        self.currentUserModel = currentUserModel
    }
}

//MARK: - ImagePickerDelegate

extension ProfileViewController: ImagePickerDelegate {
    
    func selectImage(_ image: UIImage) {
        self.avatarImageView.image = image
        presenter.didSelectNewAvatar()
    }
}
