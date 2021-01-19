//
//  NewPostViewController.swift
//  Lenta
//
//  Created by Alex on 14.01.2021.
//

import UIKit

protocol NewPostViewInput: class {
    
    func notSavedPost()
}

class NewPostViewController: UIViewController {

    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var fotoImageView: UIButton!
    
    var presenter: NewPostViewOutput!
    private var image: UIImage?
    
    deinit { print("NewPostViewController deinit") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        title = "new Post"
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
    
    @IBAction func fotoImagePress(_ sender: UIButton) {
        chooseImage()
    }
    
    @IBAction func saveButtonPress(_ sender: UIButton) {
        let description = descriptionTextView.text ?? ""
        presenter.pressSendWith(description: description, image: image)
    }
}

extension NewPostViewController: NewPostViewInput {
    
    func notSavedPost() {
        let alertContoller = UIAlertController(title: "Error", message: "not saved post", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertContoller.addAction(okAction)
        present(alertContoller, animated: true)
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
        self.image = image
        self.fotoImageView.setImage(image, for: .normal)
        dismiss(animated: true, completion: nil)
    }
}
