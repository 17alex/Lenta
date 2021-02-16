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
    @IBOutlet weak var fotoImageView: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
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
    
    //MARK: - Metods
    
    private func setup() {
        title = "Enter new post..."
        activityIndicator.hidesWhenStopped = true
    }
    
    private func chooseImage() {
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
    
    @IBAction func fotoImagePress(_ sender: UIButton) {
        chooseImage()
    }
    
    @IBAction func sendButtonPress(_ sender: UIButton) {
        sendButton.isHidden = true
        activityIndicator.startAnimating()
        let description = descriptionTextView.text ?? ""
        presenter.pressSendButton(description: description, image: fotoImageView.imageView?.image)
    }
}

// MARK: - NewPostViewInput

extension NewPostViewController: NewPostViewInput {
    
    func newPostSendFailed(text: String) {
        let alertContoller = UIAlertController(title: "Error send post", message: text, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertContoller.addAction(okAction)
        present(alertContoller, animated: true)
        sendButton.isHidden = true
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
        self.fotoImageView.setImage(image, for: .normal)
        dismiss(animated: true, completion: nil)
    }
}
