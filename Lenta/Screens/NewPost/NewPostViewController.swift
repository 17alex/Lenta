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
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var newPostTitle: UILabel!
    @IBOutlet weak var heightTextView: NSLayoutConstraint!
    @IBOutlet weak var heightImageView: NSLayoutConstraint!
    @IBOutlet weak var bottomScrollView: NSLayoutConstraint!
    
    //MARK: - Variables
    
    var presenter: NewPostViewOutput!
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
        newPostTitle.text = "Enter new post..."
        activityIndicator.hidesWhenStopped = true
        
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
        let actionSheet = UIAlertController(title: "Choose", message: "foto source", preferredStyle: .actionSheet)
        let fotoAction = UIAlertAction(title: "Foto", style: .default) { (_) in
            self.chooseImagePicker(source: .photoLibrary)
        }
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (_) in
            self.chooseImagePicker(source: .camera)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(fotoAction)
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true)
    }
    
    //MARK: - IBAction
    
    @IBAction func sendButtonPress(_ sender: UIButton) {
        sendButton.isEnabled = false
        activityIndicator.startAnimating()
        let description = descriptionTextView.text ?? ""
        presenter.pressSendButton(description: description, image: fotoImageView.image)
    }
    
    @IBAction func closeButtonPress(_ sender: UIButton) {
        dismiss(animated: true)
    }
}

//MARK: - UITextViewDelegate

extension NewPostViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: view.frame.width, height: .infinity)
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

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension NewPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image: UIImage = info[.editedImage] as? UIImage else { return }
        self.fotoImageView.image = image
        let height = image.size.height / image.size.width * fotoImageView.bounds.width
        heightImageView.constant = height
        dismiss(animated: true, completion: nil)
    }
}
