//
//  NetworkManager.swift
//  Lenta
//
//  Created by Alex on 11.01.2021.
//

import UIKit

protocol NetworkManagerProtocol {
    
    func getPosts(complete: @escaping (Result<[Post], Error>) -> Void)
    func setPost(post: SendPost)
}

class NetworkManager {
    
    private func taskResume(with url: URL, complete: @escaping (Data?, Error?) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, _, error) in
                complete(data, error)
        }.resume()
    }
    
    private func onMain(_ blok: @escaping () -> Void) {
        DispatchQueue.main.async { blok() }
    }
}

extension NetworkManager: NetworkManagerProtocol {
    
    func getPosts(complete: @escaping (Result<[Post], Error>) -> Void) {
        
        let url = URL(string: "https://monsterok.ru/lenta/getPosts.php")!
        taskResume(with: url) { data, error in
            
            guard let myData = data else { return }
            let dataString = String(data: myData, encoding: .utf8)
            print("dataString: \(dataString)")
            
            if let error = error {
                self.onMain { complete(.failure(error)) }
            } else if let data = data {
                do {
                    let posts = try JSONDecoder().decode([Post].self, from: data)
                    self.onMain { complete(.success(posts)) }
                } catch let error {
                    self.onMain { complete(.failure(error)) }
                }
            } // else NoData
        }
    }
    
    func setPost(post: SendPost) {
        let filePathKey = "file"
        let url = URL(string: "https://monsterok.ru/lenta/im.php")!
        let boundary = "Boundary-\(UUID().uuidString)"
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        var parameters: [String: String] = [:]
        parameters["description"] = post.description
        
        for (key, value) in parameters {
            body.append(Data("--\(boundary)\r\n".utf8))
            body.append(Data("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".utf8))
            body.append(Data("\(value)\r\n".utf8))
        }
        
        if let image = post.image {
            let filename = String(Int(Date().timeIntervalSince1970)) + ".jpg"
            let mimetype = "image/jpg"
            let imageData = image.jpegData(compressionQuality: 0.25)
            body.append(Data("--\(boundary)\r\n".utf8))
            body.append(Data("Content-Disposition: form-data; name=\"\(filePathKey)\"; filename=\"\(filename)\"\r\n".utf8))
            body.append(Data("Content-Type: \(mimetype)\r\n\r\n".utf8))
            body.append(imageData!)
            body.append(Data("\r\n".utf8))
            body.append(Data("--\(boundary)--\r\n".utf8))
        }
        
        urlRequest.httpBody = body
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data else { return }
            let dataString = String(data: data, encoding: .utf8)
            print("dataString: \(dataString)")
        }.resume()
    }
}
