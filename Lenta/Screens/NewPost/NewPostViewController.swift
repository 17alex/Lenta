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
    @IBOutlet weak var navItem: UINavigationItem!
    
    //MARK: - Variables
    
    var presenter: NewPostViewOutput!
    
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
        descriptionTextView.becomeFirstResponder()
    }
    
    //MARK: - Metods
    
    private func setup() {
        navItem.title = "Enter new post..."
        activityIndicator.hidesWhenStopped = true
        
        let kbToolbar = UIToolbar()
        kbToolbar.sizeToFit()
        let btn = UIBarButtonItem(image: UIImage(systemName: "photo"), style: .plain, target: self, action: #selector(chooseImage))
        kbToolbar.setItems([btn], animated: true)
        
        
        descriptionTextView.inputAccessoryView = kbToolbar
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
        dismiss(animated: true, completion: nil)
    }
}
