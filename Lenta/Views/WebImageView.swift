//
//  WebImageView.swift
//  Lenta
//
//  Created by Alex on 25.01.2021.
//

import UIKit

//TODO: - раширение для networkibga

class WebImageView: UIImageView {

    func loadImage(for url: URL, complete: @escaping (UIImage, URL) -> Void) {
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
