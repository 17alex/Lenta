//
//  ImagePicker.swift
//  Lenta
//
//  Created by Alex on 12.04.2021.
//

import UIKit

protocol ImagePickerDelegate: AnyObject {
    func selectImage(_ image: UIImage)
}

final class ImagePicker: NSObject {
    
    private unowned let view: UIViewController
    private weak var delegate: ImagePickerDelegate?
    
    init(view: UIViewController, delegate: ImagePickerDelegate) {
        self.view = view
        self.delegate = delegate
    }
    
    func chooseImage() {
        let actionSheet = UIAlertController(title: "Choose", message: "photo source", preferredStyle: .actionSheet)
        
        if  UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoAction = UIAlertAction(title: "PhotoLibrary", style: .default) { _ in
                self.selectImage(from: .photoLibrary)
            }
            actionSheet.addAction(photoAction)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
                self.selectImage(from: .camera)
            }
            actionSheet.addAction(cameraAction)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            let albumAction = UIAlertAction(title: "Album", style: .default) { _ in
                self.selectImage(from: .savedPhotosAlbum)
            }
            actionSheet.addAction(albumAction)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        
        view.present(actionSheet, animated: true)
    }
    
    private func selectImage(from source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            view.present(imagePicker, animated: true)
        }
    }
}

// MARK: - UIImagePickerControllerDelegate

extension ImagePicker: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image: UIImage = info[.editedImage] as? UIImage else { return }
        delegate?.selectImage(image)
        view.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UINavigationControllerDelegate

extension ImagePicker: UINavigationControllerDelegate { }
