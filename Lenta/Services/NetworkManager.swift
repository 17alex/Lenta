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
    func getPosts(fromPostId: Int?, complete: @escaping (Result<Response, Error>) -> Void)
    func sendPost(post: SendPost, complete: @escaping (Result<Response, Error>) -> Void)
    func updateProfile(id: Int, name: String, avatar: UIImage?, complete: @escaping (Result<[User], Error>) -> Void)
    func changeLike(postId: Int, userId: Int, complete: @escaping (Result<Post, Error>) -> Void)
    func removePost(postId: Int, complete: @escaping (Result<Response, Error>) -> Void)
    func loadComments(by postId: Int, complete: @escaping (Result<ResponseComment, Error>) -> Void)
    func sendComment(_ comment: String, postId: Int, userId: Int, complete: @escaping (Result<ResponseComment, Error>) -> Void)
}

class NetworkManager {
    
    init() {
        print("NetworkManager init")
    }
    
    deinit {
        print("NetworkManager deinit")
    }
    
    //MARK: - Metods
    
    private func taskResume(with urlRequest: URLRequest, complete: @escaping (Data?, Error?) -> Void) {
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                complete(data, error)
        }.resume()
    }
    
    private func onMain(_ blok: @escaping () -> Void) {
        DispatchQueue.main.async { blok() }
    }
    
    private func typeData(data: Data?) {
        if let myData = data, let dataString = String(data: myData, encoding: .utf8) {
            print("dataString: " + dataString)
        }
        
        if let myData = data, let dataString = try? JSONSerialization.jsonObject(with: myData, options: JSONSerialization.ReadingOptions()) {
            print("JSONSerialization: \(dataString)")
        }
    }
}

//MARK: - NetworkManagerProtocol

extension NetworkManager: NetworkManagerProtocol {
    
    func sendComment(_ comment: String, postId: Int, userId: Int, complete: @escaping (Result<ResponseComment, Error>) -> Void) {
        let url = URL(string: "https://monsterok.ru/lenta/addComment.php")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        var parameters: [String: String] = [:]
        parameters["postId"] = String(postId)
        parameters["userId"] = String(userId)
        parameters["text"] = comment
        
        let body = try? JSONEncoder().encode(parameters)
        urlRequest.httpBody = body

        taskResume(with: urlRequest) { (data, error) in
            
//            self.typeData(data: data)
            
            if let error = error {
                self.onMain { complete(.failure(error)) }
            } else if let data = data {
                do {
                    let decodePost = try JSONDecoder().decode(ResponseComment.self, from: data)
                    self.onMain { complete(.success(decodePost)) }
                } catch {
                    self.onMain { complete(.failure(error)) }
                }
            }
        }
    }
    
    func loadComments(by postId: Int, complete: @escaping (Result<ResponseComment, Error>) -> Void) {
        
        let url = URL(string: "https://monsterok.ru/lenta/getComments.php")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        let parameters = ["postId" : String(postId)]

//        parameters["postQuantity"] = String(postQuantity)
        
        let body = try? JSONEncoder().encode(parameters)
        urlRequest.httpBody = body
        
        taskResume(with: urlRequest) { data, error in
            
//            self.typeData(data: data)
            
            if let error = error {
                self.onMain { complete(.failure(error)) }
            } else if let data = data {
                do {
                    let pesponseComment = try JSONDecoder().decode(ResponseComment.self, from: data)
                    self.onMain { complete(.success(pesponseComment)) }
                } catch let error {
                    print("error = ", error)
                    self.onMain { complete(.failure(error)) }
                }
            }
        }
    }
    
    func removePost(postId: Int, complete: @escaping (Result<Response, Error>) -> Void) {
        let url = URL(string: "https://monsterok.ru/lenta/removePost.php")!
        var urlRequest = URLRequest(url: url)
//        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.httpMethod = "POST"
        
        let parameters = ["postId": postId]
        let body = try? JSONEncoder().encode(parameters)
        urlRequest.httpBody = body
        
        taskResume(with: urlRequest) { (data, error) in
            
//            self.typeData(data: data)
            
            if let error = error {
                self.onMain { complete(.failure(error)) }
            } else if let data = data {
                do {
                    let pesponse = try JSONDecoder().decode(Response.self, from: data)
                    self.onMain { complete(.success(pesponse)) }
                } catch let error {
                    self.onMain { complete(.failure(error)) }
                }
            }
        }
    }
    
    func changeLike(postId: Int, userId: Int, complete: @escaping (Result<Post, Error>) -> Void) {
        let url = URL(string: "https://monsterok.ru/lenta/changeLike.php")!
        var urlRequest = URLRequest(url: url)
//        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.httpMethod = "POST"
        
        var parameters: [String: String] = [:]
        parameters["postId"] = String(postId)
        parameters["userId"] = String(userId)
        
        let body = try? JSONEncoder().encode(parameters)
        urlRequest.httpBody = body

        taskResume(with: urlRequest) { (data, error) in
            
//            self.typeData(data: data)
            
            if let error = error {
                self.onMain { complete(.failure(error)) }
            } else if let data = data {
                do {
                    let decodePost = try JSONDecoder().decode(Post.self, from: data)
                    self.onMain { complete(.success(decodePost)) }
                } catch {
                    self.onMain { complete(.failure(error)) }
                }
            }
        }
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
            
//            self.typeData(data: data)
            
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
        
//        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        var parameters: [String: String] = [:]
        parameters["login"] = String(login)
        parameters["password"] = String(password)
        
        let body = try? JSONEncoder().encode(parameters)
        urlRequest.httpBody = body

        taskResume(with: urlRequest) { (data, error) in
            
//            self.typeData(data: data)
            
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
            
//            self.typeData(data: data)
            
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
    
    func getPosts(fromPostId: Int? = nil, complete: @escaping (Result<Response, Error>) -> Void) {
        let url = URL(string: "https://monsterok.ru/lenta/getPosts.php")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        var parameters: [String: String] = [:]
        if let fromPostId = fromPostId {
            parameters["fromPostId"] = String(fromPostId)
        }
//        parameters["postQuantity"] = String(postQuantity)
        
        let body = try? JSONEncoder().encode(parameters)
        urlRequest.httpBody = body
        
        taskResume(with: urlRequest) { data, error in
            
//            self.typeData(data: data)
            
            if let error = error {
                self.onMain { complete(.failure(error)) }
            } else if let data = data {
                do {
                    let pesponse = try JSONDecoder().decode(Response.self, from: data)
                    self.onMain { complete(.success(pesponse)) }
                } catch let error {
                    self.onMain { complete(.failure(error)) }
                }
            }
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
            
//            self.typeData(data: data)
            
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
            }
        }
    }
}
