//
//  LoginViewController.swift
//  Lenta
//
//  Created by Alex on 18.01.2021.
//

import UIKit

protocol LoginViewInput: AnyObject {
    func userNotLoginned(message: String)
}

final class LoginViewController: UIViewController {

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

    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGray5
        button.addTarget(self, action: #selector(loginButtonPress), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        button.addTarget(self, action: #selector(registerButtonPress), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var loginTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.accessibilityIdentifier = "loginTextField"
        textField.clearButtonMode = .always
        textField.delegate = self
        textField.addTarget(self, action: #selector(valueChangeTextField), for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.accessibilityIdentifier = "passwordTextField"
        textField.clearButtonMode = .always
        textField.isSecureTextEntry = true
        textField.delegate = self
        textField.addTarget(self, action: #selector(valueChangeTextField), for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let textLoginTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Login"
        label.font = UIFont.systemFont(ofSize: 28, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let textLoginLabel: UILabel = {
        let label = UILabel()
        label.text = "Login:"
        label.font = UIFont.systemFont(ofSize: 17, weight: .thin)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let textPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "Password:"
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

    var presenter: LoginViewOutput?

    // MARK: - LiveCycles

    override func viewDidLoad() {
        super.viewDidLoad()
        print("LoginViewController init")

        setupUI()
    }

    deinit {
        print("LoginViewController deinit")
    }

    // MARK: - Methods

    @objc private func registerButtonPress() {
        presenter?.registerButtonPress()
    }

    @objc private func valueChangeTextField() {
        if loginTextField.hasText, passwordTextField.hasText {
            enableLoginButton()
        } else {
            disableLoginButton()
        }
    }

    @objc private func loginButtonPress() {
        guard let login = loginTextField.text, let password = passwordTextField.text else { return }
        loginButton.isHidden = true
        activityIndicator.startAnimating()
        presenter?.logIn(login: login, password: password)
    }

    @objc private func closeButtonPress() {
        dismiss(animated: true)
    }

    private func enableLoginButton() {
        self.loginButton.isEnabled = true
        self.loginButton.backgroundColor = Constants.Colors.active
    }

    private func disableLoginButton() {
        self.loginButton.isEnabled = false
        self.loginButton.backgroundColor = Constants.Colors.deActive
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        loginButton.isEnabled = false
        loginTextField.becomeFirstResponder()

        view.addSubview(loginButton)
        view.addSubview(registerButton)
        view.addSubview(loginTextField)
        view.addSubview(passwordTextField)
        view.addSubview(textLoginTitleLabel)
        view.addSubview(textLoginLabel)
        view.addSubview(textPasswordLabel)
        view.addSubview(activityIndicator)
        view.addSubview(navigationBar)

        textPasswordLabel.setContentHuggingPriority(.init(500), for: .horizontal)
        addConstraints()
        loginButton.layer.cornerRadius = 20
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            loginButton.heightAnchor.constraint(equalToConstant: 40),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            textPasswordLabel.leadingAnchor.constraint(equalTo: loginButton.leadingAnchor),
            textPasswordLabel.firstBaselineAnchor.constraint(equalTo: passwordTextField.firstBaselineAnchor),
            textPasswordLabel.trailingAnchor.constraint(equalTo: passwordTextField.leadingAnchor, constant: -8),

            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            passwordTextField.bottomAnchor.constraint(equalTo: loginButton.topAnchor, constant: -16),

            loginTextField.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
            loginTextField.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),
            loginTextField.bottomAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: -16),

            textLoginLabel.trailingAnchor.constraint(equalTo: textPasswordLabel.trailingAnchor),
            textLoginLabel.firstBaselineAnchor.constraint(equalTo: loginTextField.firstBaselineAnchor),

            textLoginTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textLoginTitleLabel.bottomAnchor.constraint(equalTo: loginTextField.topAnchor, constant: -24),

            registerButton.trailingAnchor.constraint(equalTo: loginButton.trailingAnchor),
            registerButton.bottomAnchor.constraint(equalTo: loginTextField.topAnchor, constant: -24),

            activityIndicator.centerXAnchor.constraint(equalTo: loginButton.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: loginButton.centerYAnchor)
        ])
    }
}

// MARK: - LoginViewInput

extension LoginViewController: LoginViewInput {

    func userNotLoginned(message: String) {
        activityIndicator.stopAnimating()
        loginButton.isHidden = false
        let alertController = UIAlertController(title: "Error loginned", message: message, preferredStyle: .alert)
        let okAlertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(okAlertAction)
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case loginTextField: passwordTextField.becomeFirstResponder()
        case passwordTextField: passwordTextField.resignFirstResponder()
        default: break
        }

        return true
    }
}
