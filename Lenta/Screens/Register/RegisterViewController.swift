//
//  RegisterViewController.swift
//  Lenta
//
//  Created by Alex on 19.01.2021.
//

import UIKit

protocol RegisterViewInput: AnyObject {
    func userNotRegister(message: String)
}

final class RegisterViewController: UIViewController {

    // MARK: - Properties

    private lazy var navItem: UINavigationItem = {
        let navItem = UINavigationItem(title: "")
        navItem.rightBarButtonItem = closeButton
        return navItem
    }()

    private lazy var navigationBar: UINavigationBar = {
        let navBar = UINavigationBar()
        navBar.items = [navItem]
        navBar.isTranslucent = false
        navBar.translatesAutoresizingMaskIntoConstraints = false
        return navBar
    }()

    private lazy var avatarButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "avatar"), for: .normal)
        button.addTarget(self, action: #selector(addAvatarButtonPress), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var logInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        button.addTarget(self, action: #selector(logInButtonPress), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGray5
        button.addTarget(self, action: #selector(registerButtonPress), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textField.addTarget(self, action: #selector(didChangeText), for: .editingChanged)
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .sentences
        textField.clearButtonMode = .always
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var loginTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textField.addTarget(self, action: #selector(didChangeText), for: .editingChanged)
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.clearButtonMode = .always
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textField.addTarget(self, action: #selector(didChangeText), for: .editingChanged)
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.clearButtonMode = .always
        textField.isSecureTextEntry = true
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let textRegisterLabel: UILabel = {
        let label = UILabel()
        label.text = "Register"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 28, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let textNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name:"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .thin)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let textLoginLabel: UILabel = {
        let label = UILabel()
        label.text = "Login:"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .thin)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let textPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "Password:"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .thin)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .medium
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()

    private lazy var closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: self,
                                                   action: #selector(closeButtonPress))

    var presenter: RegisterViewOutput?
    private var avatarImage: UIImage?
    lazy var imagePicker = ImagePicker(view: self, delegate: self)

    // MARK: - LiveCycles

    override func viewDidLoad() {
        super.viewDidLoad()
        print("RegisterViewController init")

        setupUI()
    }

    deinit {
        print("RegisterViewController deinit")
    }

    // MARK: - Methods

    @objc private func addAvatarButtonPress() {
        imagePicker.chooseImage()
    }

    @objc private func logInButtonPress() {
        presenter?.signInButtonPress()
    }

    @objc private func didChangeText() {
        if nameTextField.hasText, loginTextField.hasText, passwordTextField.hasText {
            enableRegisterButton()
        } else {
            disableRegisterButton()
        }
    }

    @objc private func registerButtonPress() {
        guard let name = nameTextField.text,
              let login = loginTextField.text,
              let password = passwordTextField.text else { return }
        registerButton.isHidden = true
        activityIndicator.startAnimating()
        presenter?.registerButtonPress(name: name, login: login, password: password, avatarImage: avatarImage)
    }

    @objc private func closeButtonPress() {
        dismiss(animated: true)
    }

    private func enableRegisterButton() {
        self.registerButton.isEnabled = true
        self.registerButton.backgroundColor = Constants.Colors.active
    }

    private func disableRegisterButton() {
        self.registerButton.isEnabled = false
        self.registerButton.backgroundColor = Constants.Colors.deActive
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        registerButton.isEnabled = false
        nameTextField.becomeFirstResponder()

        view.addSubview(avatarButton)
        view.addSubview(logInButton)
        view.addSubview(registerButton)
        view.addSubview(nameTextField)
        view.addSubview(loginTextField)
        view.addSubview(passwordTextField)
        view.addSubview(textRegisterLabel)
        view.addSubview(textNameLabel)
        view.addSubview(textLoginLabel)
        view.addSubview(textPasswordLabel)
        view.addSubview(activityIndicator)
        view.addSubview(navigationBar)

        textPasswordLabel.setContentHuggingPriority(.init(500), for: .horizontal)

        addConstraints()

        registerButton.layer.cornerRadius = 20
        avatarButton.layer.cornerRadius = 30
        avatarButton.clipsToBounds = true
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            registerButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            registerButton.heightAnchor.constraint(equalToConstant: 40),
            registerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            textPasswordLabel.leadingAnchor.constraint(equalTo: registerButton.leadingAnchor),
            textPasswordLabel.firstBaselineAnchor.constraint(equalTo: passwordTextField.firstBaselineAnchor),
            textPasswordLabel.trailingAnchor.constraint(equalTo: passwordTextField.leadingAnchor, constant: -8),

            passwordTextField.trailingAnchor.constraint(equalTo: registerButton.trailingAnchor),
            passwordTextField.bottomAnchor.constraint(equalTo: registerButton.topAnchor, constant: -8),

            loginTextField.bottomAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: -8),
            loginTextField.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
            loginTextField.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),

            nameTextField.bottomAnchor.constraint(equalTo: loginTextField.topAnchor, constant: -8),
            nameTextField.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),

            textLoginLabel.trailingAnchor.constraint(equalTo: textPasswordLabel.trailingAnchor),
            textLoginLabel.firstBaselineAnchor.constraint(equalTo: loginTextField.firstBaselineAnchor),

            textNameLabel.trailingAnchor.constraint(equalTo: textPasswordLabel.trailingAnchor),
            textNameLabel.firstBaselineAnchor.constraint(equalTo: nameTextField.firstBaselineAnchor),

            textRegisterLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textRegisterLabel.bottomAnchor.constraint(equalTo: nameTextField.topAnchor, constant: -24),

            avatarButton.heightAnchor.constraint(equalToConstant: 60),
            avatarButton.widthAnchor.constraint(equalToConstant: 60),
            avatarButton.bottomAnchor.constraint(equalTo: nameTextField.topAnchor, constant: -8),
            avatarButton.trailingAnchor.constraint(equalTo: nameTextField.leadingAnchor, constant: -16),

            logInButton.bottomAnchor.constraint(equalTo: nameTextField.topAnchor, constant: -24),
            logInButton.trailingAnchor.constraint(equalTo: registerButton.trailingAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: registerButton.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: registerButton.centerYAnchor)
        ])
    }
}

// MARK: - RegisterViewInput

extension RegisterViewController: RegisterViewInput {

    func userNotRegister(message: String) {
        activityIndicator.stopAnimating()
        registerButton.isHidden = false

        let alertController = UIAlertController(title: "Error register", message: message, preferredStyle: .alert)
        let okAlertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(okAlertAction)
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UITextFieldDelegate

extension RegisterViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameTextField: loginTextField.becomeFirstResponder()
        case loginTextField: passwordTextField.becomeFirstResponder()
        case passwordTextField: passwordTextField.resignFirstResponder()
        default: break
        }

        return true
    }
}

// MARK: - ImagePickerDelegate

extension RegisterViewController: ImagePickerDelegate {

    func selectImage(_ image: UIImage) {
        avatarImage = image
        avatarButton.setImage(image, for: .normal)
    }
}
