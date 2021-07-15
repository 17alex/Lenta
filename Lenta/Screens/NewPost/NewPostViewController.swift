//
//  NewPostViewController.swift
//  Lenta
//
//  Created by Alex on 14.01.2021.
//

import UIKit

protocol NewPostViewInput: AnyObject {
    func newPostSendFailed(text: String)
}

final class NewPostViewController: UIViewController {

    // MARK: - Propertis

    private lazy var navItem: UINavigationItem = {
        let navItem = UINavigationItem(title: "Enter new post...")
        navItem.leftBarButtonItem = closeButton
        navItem.rightBarButtonItem = sendButton
        return navItem
    }()

    private lazy var navigationBar: UINavigationBar = {
        let navBar = UINavigationBar()
        navBar.items = [navItem]
        navBar.translatesAutoresizingMaskIntoConstraints = false
        return navBar
    }()

    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 17, weight: .light)
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.inputAccessoryView = toolbar
        textView.delegate = self
        return textView
    }()

    private lazy var toolbar: UIToolbar = {
        let kbToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
        kbToolbar.barStyle = UIBarStyle.default
        kbToolbar.isTranslucent = true
        let button = UIBarButtonItem(image: UIImage(systemName: "photo"),
                                     style: .plain, target: self, action: #selector(chooseImage))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        kbToolbar.setItems([button, space], animated: false)
        kbToolbar.isUserInteractionEnabled = true
        kbToolbar.sizeToFit()
        return kbToolbar
    }()

    private lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(photoTap)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(style: .medium)
        activity.translatesAutoresizingMaskIntoConstraints = false
        return activity
    }()

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private lazy var sendButton = UIBarButtonItem(image: UIImage(systemName: "arrow.up.circle"),
                                                  style: .plain, target: self, action: #selector(sendButtonPress))
    private lazy var closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: self,
                                                   action: #selector(closeButtonPress))
    private lazy var photoTap = UITapGestureRecognizer(target: self, action: #selector(didTapPhoto))

    private var heightTextView: NSLayoutConstraint?
    private var heightImageView: NSLayoutConstraint?
    private var bottomScrollView: NSLayoutConstraint?

    var presenter: NewPostViewOutput?

    private lazy var imagePicker = ImagePicker(view: self, delegate: self)
    private var isShowKboard = false

    // MARK: - LiveCycles

    deinit {
        print("NewPostViewController deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("NewPostViewController init")

        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        subscribeKboardNotofication()
        descriptionTextView.becomeFirstResponder()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        unSubscribeKboardNotofication()
    }

    // MARK: - Metods

    private func subscribeKboardNotofication() {
        NotificationCenter.default.addObserver(self, selector: #selector(willShowKboard(notification:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willHideKboard(notification:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func unSubscribeKboardNotofication() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func willShowKboard(notification: NSNotification) {
        if isShowKboard { return }
        isShowKboard = true

        guard let userInfo = notification.userInfo,
              let animDuration = userInfo["UIKeyboardAnimationDurationUserInfoKey"] as? Double,
              let kbFrameEndUserInfoKey = userInfo["UIKeyboardFrameEndUserInfoKey"] as? NSValue else { return }
        let kbFrameSize = (kbFrameEndUserInfoKey).cgRectValue
        let offset = kbFrameSize.height

        UIView.animate(withDuration: animDuration) {
            self.bottomScrollView?.constant = -offset
            self.view.layoutIfNeeded()
        }
    }

    @objc private func willHideKboard(notification: NSNotification) {
        if !isShowKboard { return }
        isShowKboard = false

        guard let userInfo = notification.userInfo,
              let animDuration = userInfo["UIKeyboardAnimationDurationUserInfoKey"] as? Double else { return }

        UIView.animate(withDuration: animDuration) {
            self.bottomScrollView?.constant = 0
            self.view.layoutIfNeeded()
        }
    }

    @objc private func didTapPhoto() {
        descriptionTextView.resignFirstResponder()
    }

    @objc private func chooseImage() {
        imagePicker.chooseImage()
    }

    @objc private func sendButtonPress() {
        sendButton.isEnabled = false
        activityIndicator.startAnimating()
        let description = descriptionTextView.text ?? ""
        presenter?.pressSendButton(description: description, image: photoImageView.image)
    }

    @objc private func closeButtonPress() {
        dismiss(animated: true)
    }

    private func updateContSize() {
        scrollView.contentSize = CGSize(width: view.bounds.width,
                                        height: (heightTextView?.constant ?? 0) + (heightImageView?.constant ?? 0))
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground

        view.addSubview(navigationBar)
        view.addSubview(scrollView)
        scrollView.addSubview(descriptionTextView)
        scrollView.addSubview(photoImageView)
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),

            photoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            photoImageView.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            activityIndicator.centerYAnchor.constraint(equalTo: navigationBar.centerYAnchor),
            activityIndicator.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor, constant: -58)
        ])

        bottomScrollView = scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        bottomScrollView?.isActive = true
        bottomScrollView?.constant = 0

        heightTextView = descriptionTextView.heightAnchor.constraint(equalToConstant: 36)
        heightTextView?.isActive = true

        heightImageView = photoImageView.heightAnchor.constraint(equalToConstant: 0)
        heightImageView?.isActive = true
    }
}

// MARK: - UITextViewDelegate

extension NewPostViewController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = descriptionTextView.sizeThatFits(size)
        heightTextView?.constant = estimatedSize.height
        updateContSize()
    }
}

// MARK: - NewPostViewInput

extension NewPostViewController: NewPostViewInput {

    func newPostSendFailed(text: String) {
        let alertContoller = UIAlertController(title: "Error send post", message: text, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertContoller.addAction(okAction)
        present(alertContoller, animated: true)
        sendButton.isEnabled = true
        activityIndicator.stopAnimating()
    }
}

// MARK: - ImagePickerDelegate

extension NewPostViewController: ImagePickerDelegate {

    func selectImage(_ image: UIImage) {
        photoImageView.image = image
        let height = image.size.height / image.size.width * photoImageView.bounds.width
        heightImageView?.constant = height
        updateContSize()
    }
}
