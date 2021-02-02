//
//  NetworkManager.swift
//  Lenta
//
//  Created by Alex on 11.01.2021.
//

import UIKit

protocol NetworkManagerProtocol {
    
    func logIn(login: String, password: String, complete: @escaping (Result<[User], Error>) -> Void)
    func register(name: String, login: String, password: String, avatar: UIImage?,  complete: @escaping (Result<[User], Error>) -> Void)
    func getPosts(complete: @escaping (Result<Response, Error>) -> Void)
    func sendPost(post: SendPost, complete: @escaping (Result<Response, Error>) -> Void)
    func updateProfile(id: Int, name: String, avatar: UIImage?, complete: @escaping (Result<[User], Error>) -> Void)
}

class NetworkManager {
    
    init() {
        print("NetworkManager init")
    }
    
    deinit {
        print("NetworkManager deinit")
    }
    
    private func taskResume(with urlRequest: URLRequest, complete: @escaping (Data?, Error?) -> Void) {
        URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
                complete(data, error)
        }.resume()
    }
    
    private func onMain(_ blok: @escaping () -> Void) {
        DispatchQueue.main.async { blok() }
    }
}

extension NetworkManager: NetworkManagerProtocol {
    // TODO: - dictionary
    struct Sendlogin: Encodable {
        let login: String
        let password: String
    }
    
    struct SendRegister: Encodable {
        let name: String
        let login: String
        let password: String
    }
    
    func updateProfile(id: Int, name: String, avatar: UIImage?, complete: @escaping (Result<[User], Error>) -> Void) {
        let filePathKey = "file"
        let url = URL(string: "https://monsterok.ru/lenta/updatePrifile.php")!
        let boundary = "Boundary-\(UUID().uuidString)"
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        var parameters: [String: String] = [:]
        parameters["id"] = String(id)
        parameters["name"] = name
//        parameters["login"] = login
//        parameters["password"] = password
        
        for (key, value) in parameters {
            body.append(Data("--\(boundary)\r\n".utf8))
            body.append(Data("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".utf8))
            body.append(Data("\(value)\r\n".utf8))
        }
        
        if let image = avatar {
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
        
        taskResume(with: urlRequest) { (data, error) in
            
//            if let myData = data {
//                let dataString = String(data: myData, encoding: .utf8)
//                print("dataString: \(dataString)")
//            }
            
            if let error = error {
                self.onMain { complete(.failure(error)) }
            } else {
                var users: [User] = []
                if let data = data, let decodeUsers = try? JSONDecoder().decode([User].self, from: data) {
                    users = decodeUsers
                }
                self.onMain { complete(.success(users)) }
            }
        }
    }
    
    func logIn(login: String, password: String, complete: @escaping (Result<[User], Error>) -> Void) {
        let url = URL(string: "https://monsterok.ru/lenta/login.php")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        let parameters = Sendlogin(login: login, password: password)
        let body = try? JSONEncoder().encode(parameters)
        urlRequest.httpBody = body

        taskResume(with: urlRequest) { (data, error) in
            
//            if let myData = data {
//                let dataString = String(data: myData, encoding: .utf8)
//                print("dataString: \(dataString)")
//            }
            
            if let error = error {
                self.onMain { complete(.failure(error)) }
            } else {
                var users: [User] = []
                if let data = data,
                   let decodeUsers = try? JSONDecoder().decode([User].self, from: data) {
                    users = decodeUsers
                }
                self.onMain { complete(.success(users)) }
            }
        }
    }
    
    func register(name: String, login: String, password: String, avatar: UIImage?, complete: @escaping (Result<[User], Error>) -> Void) {
        let filePathKey = "file"
        let url = URL(string: "https://monsterok.ru/lenta/register.php")!
        let boundary = "Boundary-\(UUID().uuidString)"
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        var parameters: [String: String] = [:]
        parameters["name"] = name
        parameters["login"] = login
        parameters["password"] = password
        
        for (key, value) in parameters {
            body.append(Data("--\(boundary)\r\n".utf8))
            body.append(Data("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".utf8))
            body.append(Data("\(value)\r\n".utf8))
        }
        
        if let image = avatar {
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
        
        taskResume(with: urlRequest) { (data, error) in
            
//            if let myData = data {
//                let dataString = String(data: myData, encoding: .utf8)
//                print("dataString: \(dataString)")
//            }
            
            if let error = error {
                self.onMain { complete(.failure(error)) }
            } else {
                var users: [User] = []
                if let data = data,
                   let decodeUsers = try? JSONDecoder().decode([User].self, from: data) {
                    users = decodeUsers
                }
                self.onMain { complete(.success(users)) }
            }
        }
    }
    
    func getPosts(complete: @escaping (Result<Response, Error>) -> Void) {
        let url = URL(string: "https://monsterok.ru/lenta/getPosts.php")!
        let urlRequest = URLRequest(url: url)
        taskResume(with: urlRequest) { data, error in
            
//            if let myData = data {
//                let dataString = String(data: myData, encoding: .utf8)
//                print("dataString: \(dataString)")
//            }
            print("recive getPost")
            
            if let error = error {
                self.onMain { complete(.failure(error)) }
            } else if let data = data {
                do {
                    let pesponse = try JSONDecoder().decode(Response.self, from: data)
                    self.onMain { complete(.success(pesponse)) }
                } catch let error {
                    self.onMain { complete(.failure(error)) }
                }
            } // else NoData
        }
    }
    
    func sendPost(post: SendPost, complete: @escaping (Result<Response, Error>) -> Void) {
        let filePathKey = "file"
        let url = URL(string: "https://monsterok.ru/lenta/addPost.php")!
        let boundary = "Boundary-\(UUID().uuidString)"
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        var parameters: [String: String] = [:]
        parameters["userId"] = String(post.userId)
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
        
        taskResume(with: urlRequest) { (data, error) in
            
//            if let myData = data {
//                let dataString = String(data: myData, encoding: .utf8)
//                print("dataString: \(dataString)")
//            }
            
            if let error = error {
                self.onMain { complete(.failure(error)) }
            } else {
                if let data = data {
                    do {
                        let pesponse = try JSONDecoder().decode(Response.self, from: data)
                        self.onMain { complete(.success(pesponse)) }
                    } catch let error {
                        self.onMain { complete(.failure(error)) }
                    }
                }
            } // NoData
        }
    }
}
