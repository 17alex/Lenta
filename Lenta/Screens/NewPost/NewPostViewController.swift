//
//  NewPostViewController.swift
//  Lenta
//
//  Created by Alex on 14.01.2021.
//

import UIKit

protocol NewPostViewInput: class {
    func newPostSendFailed(text: String)
}

class NewPostViewController: UIViewController {

    //MARK: - IBOutlets
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var fotoImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var sendButton: UIBarButtonItem!
    @IBOutlet weak var heightTextView: NSLayoutConstraint!
    @IBOutlet weak var heightImageView: NSLayoutConstraint!
    @IBOutlet weak var bottomScrollView: NSLayoutConstraint!
    
    //MARK: - Propertis
    
    var presenter: NewPostViewOutput!
    lazy var imagePicker = ImagePicker(view: self, delegate: self)
    var kbIsShow = false
    
    //MARK: - LiveCycles
    
    deinit {
        print("NewPostViewController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("NewPostViewController init")
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(willShowKboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willHideKboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        descriptionTextView.becomeFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: - Metods
    
    @objc private func willShowKboard(notification: NSNotification) {
        if kbIsShow == true { return }
        kbIsShow = true
        
        guard let userInfo = notification.userInfo else { return }
        let kbFrameSize = (userInfo["UIKeyboardFrameEndUserInfoKey"] as! NSValue).cgRectValue
        let offset = kbFrameSize.height
        
        UIView.animate(withDuration: 0.5) {
            self.bottomScrollView.constant = -offset
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func willHideKboard() {
        if kbIsShow == false { return }
        kbIsShow = false
        
        UIView.animate(withDuration: 0.5) {
            self.bottomScrollView.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func didTapPhoto() {
        descriptionTextView.resignFirstResponder()
    }
    
    private func setup() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapPhoto))
        fotoImageView.addGestureRecognizer(tap)
        
        let kbToolbar = UIToolbar()
        kbToolbar.sizeToFit()
        let btn = UIBarButtonItem(image: UIImage(systemName: "photo"), style: .plain, target: self, action: #selector(chooseImage))
        let spc = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        kbToolbar.setItems([btn, spc], animated: true)
        descriptionTextView.inputAccessoryView = kbToolbar
        descriptionTextView.delegate = self
    }
    
    @objc private func chooseImage() {
        imagePicker.chooseImage()
    }
    
    //MARK: - IBAction
    
    @IBAction func sendButtonPress(_ sender: UIBarButtonItem) {
        sendButton.isEnabled = false
        activityIndicator.startAnimating()
        let description = descriptionTextView.text ?? ""
        presenter.pressSendButton(description: description, image: fotoImageView.image)
    }
    
    @IBAction func closeButtonPress(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}

//MARK: - UITextViewDelegate

extension NewPostViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: view.frame.width, height: .infinity)
        //TODO: - view.frame.width -> descriptionTextView.frame.width
        let estimatedSize = descriptionTextView.sizeThatFits(size)
        heightTextView.constant = estimatedSize.height
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

//MARK: - ImagePickerDelegate

extension NewPostViewController: ImagePickerDelegate {
    
    func selectImage(_ image: UIImage) {
        fotoImageView.image = image
        let height = image.size.height / image.size.width * fotoImageView.bounds.width
        heightImageView.constant = height
    }
}
