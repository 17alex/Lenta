//
//  WebImageView.swift
//  Lenta
//
//  Created by Alex on 09.03.2021.
//

import UIKit

class WebImageView: UIImageView {
    
    var imageUrlString: String = ""
    //TODO: - activity inside
    func load(by urlString: String, complete: @escaping () -> Void) {
        if urlString != "", let url = URL(string: urlString) {
            imageUrlString = urlString
            loadImage(for: url) { (image, imageUrl) in
                if self.imageUrlString == imageUrl.absoluteString {
                    self.image = image
                }
            }
        }
    }
    
    private func loadImage(for url: URL, complete: @escaping (UIImage, URL) -> Void) {
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
