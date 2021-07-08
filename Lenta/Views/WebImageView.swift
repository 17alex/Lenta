//
//  WebImageView.swift
//  Lenta
//
//  Created by Alex on 09.03.2021.
//

import UIKit

class WebImageView: UIImageView {
    
    //MARk: - Propertis
    
    var imageUrlString: String = ""
    
    //MARK: - Metods
    
    func load(by urlString: String, complete: (() -> Void)? = nil) {
        
        if urlString != imageUrlString {
            image = nil
        }
        
        guard let url = URL(string: urlString) else { return }
        imageUrlString = urlString
        loadImage(from: url) { [weak self] (image, imageUrl) in
            guard let strongSelf = self else { return }
            if strongSelf.imageUrlString == imageUrl.absoluteString {
                strongSelf.image = image
                complete?()
            }
        }
        
//        if !urlString.isEmpty, let url = URL(string: urlString) {
//            imageUrlString = urlString
//            loadImage(for: url) { (image, imageUrl) in
//                if self.imageUrlString == imageUrl.absoluteString {
//                    self.image = image
//                    complete?()
//                }
//            }
//        }
    }
    
    private func loadImage(from url: URL, complete: @escaping (UIImage, URL) -> Void) {
        let urlRequest = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)
        URLSession.shared.dataTask(with: urlRequest) { (data, _, _) in
            if let data = data, let loadImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    complete(loadImage, url)
                }
            }
        }.resume()
    }
}
