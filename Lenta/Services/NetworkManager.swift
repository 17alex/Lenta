//
//  NetworkManager.swift
//  Lenta
//
//  Created by Alex on 11.01.2021.
//

import UIKit

enum Constants {
    enum URLs {
        static let getComments = "https://monsterok.ru/lenta/getComments.php"
        static let getPosts = "https://monsterok.ru/lenta/getPosts.php"
        static let sendComment = "https://monsterok.ru/lenta/addComment.php"
        static let removePost = "https://monsterok.ru/lenta/removePost.php"
        static let changeLike = "https://monsterok.ru/lenta/changeLike.php"
        static let login = "https://monsterok.ru/lenta/login.php"
        static let sendPost = "https://monsterok.ru/lenta/addPost.php"
        static let register = "https://monsterok.ru/lenta/register.php"
        static let updatePrifile = "https://monsterok.ru/lenta/updatePrifile.php"
    }
}

enum NetworkServiceError: Error {
    case badUrl
    case network(str: String)
    case decodable
    case unknown
}

protocol NetworkManagerProtocol {
    
    func logIn(login: String, password: String, complete: @escaping (Result<[User], NetworkServiceError>) -> Void)
    func register(name: String, login: String, password: String, avatar: UIImage?,  complete: @escaping (Result<[User], NetworkServiceError>) -> Void)
    func getPosts(fromPostId: Int?, complete: @escaping (Result<Response, NetworkServiceError>) -> Void)
    func sendPost(post: SendPost, complete: @escaping (Result<Response, NetworkServiceError>) -> Void)
    func updateProfile(id: Int, name: String, avatar: UIImage?, complete: @escaping (Result<[User], NetworkServiceError>) -> Void)
    func changeLike(postId: Int, userId: Int, complete: @escaping (Result<Post, NetworkServiceError>) -> Void)
    func removePost(postId: Int, complete: @escaping (Result<Response, NetworkServiceError>) -> Void)
    func loadComments(for postId: Int, complete: @escaping (Result<ResponseComment, NetworkServiceError>) -> Void)
    func sendComment(_ comment: String, postId: Int, userId: Int, complete: @escaping (Result<ResponseComment, NetworkServiceError>) -> Void)
}

final class NetworkManager {
    
    //MARK: - Init
    
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
    
    private func typeDebug(data: Data?) {
        if let myData = data, let dataString = String(data: myData, encoding: .utf8) {
            print("dataString: " + dataString)
        }
        
//        if let myData = data, let dataString = try? JSONSerialization.jsonObject(with: myData, options: JSONSerialization.ReadingOptions()) {
//            print("JSONSerialization: \(dataString)")
//        }
    }
}

//MARK: - NetworkManagerProtocol

extension NetworkManager: NetworkManagerProtocol {
    
    func sendComment(_ comment: String, postId: Int, userId: Int, complete: @escaping (Result<ResponseComment, NetworkServiceError>) -> Void) {
        
        let urlString = Constants.URLs.sendComment
        
        guard let url = URL(string: urlString) else { complete(.failure(.badUrl)); return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST" //FIXME: - update and delete comment
        let postSting = "comment=\(comment)&postId=\(postId)&userId=\(userId)"
        urlRequest.httpBody = postSting.data(using: .utf8)
        
        taskResume(with: urlRequest) { (data, error) in
            
//            self.typeDebug(data: data)
            
            if let error = error {
                self.onMain { complete(.failure(.network(str: error.localizedDescription))) }
            } else if let data = data {
                do {
                    let decodePost = try JSONDecoder().decode(ResponseComment.self, from: data)
                    self.onMain { complete(.success(decodePost)) }
                } catch {
                    self.onMain { complete(.failure(.decodable)) }
                }
            }
        }
    }
    
    func loadComments(for postId: Int, complete: @escaping (Result<ResponseComment, NetworkServiceError>) -> Void) {
        
        let urlString = Constants.URLs.getComments
        
        var components = URLComponents(string: urlString)
        components?.queryItems = [
            URLQueryItem(name: "postId", value: String(postId)),
            //URLQueryItem(name: "fromCommentId", value: String(postId)), //FIXME: - pagination, server otdaet po 20
        ]
        
        guard let url = components?.url else { complete(.failure(.badUrl)); return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        taskResume(with: urlRequest) { data, error in
            
//            self.typeBebug(data: data)
            
            if let error = error {
                self.onMain { complete(.failure(.network(str: error.localizedDescription))) }
            } else if let data = data {
                do {
                    let pesponseComment = try JSONDecoder().decode(ResponseComment.self, from: data)
                    self.onMain { complete(.success(pesponseComment)) }
                } catch let error {
                    print("error = ", error)
                    self.onMain { complete(.failure(.decodable)) }
                }
            }
        }
    }
    
    func getPosts(fromPostId: Int? = nil, complete: @escaping (Result<Response, NetworkServiceError>) -> Void) {
        
        let urlString = Constants.URLs.getPosts

        var components = URLComponents(string: urlString)
        if let fromPostId = fromPostId {
            components?.queryItems = [
                URLQueryItem(name: "fromPostId", value: String(fromPostId)),
            ]
        }
        
        guard let url = components?.url else { complete(.failure(.badUrl)); return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        taskResume(with: urlRequest) { data, error in
            
//            self.typeDebug(data: data)
            
            if let error = error {
                self.onMain { complete(.failure(.network(str: error.localizedDescription))) }
            } else if let data = data {
                do {
                    let pesponse = try JSONDecoder().decode(Response.self, from: data)
                    self.onMain { complete(.success(pesponse)) }
                } catch let error {
                    print("error =", error.localizedDescription)
                    self.onMain { complete(.failure(.decodable)) }
                }
            }
        }
    }
    
    func removePost(postId: Int, complete: @escaping (Result<Response, NetworkServiceError>) -> Void) {
        
        let urlString = Constants.URLs.removePost
        
        guard let url = URL(string: urlString) else { complete(.failure(.badUrl)); return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        let postSting = "postId=\(postId)"
        urlRequest.httpBody = postSting.data(using: .utf8)
        
        taskResume(with: urlRequest) { (data, error) in
            
//            self.typeDebug(data: data)
            
            if let error = error {
                self.onMain { complete(.failure(.network(str: error.localizedDescription))) }
            } else if let data = data {
                do {
                    let pesponse = try JSONDecoder().decode(Response.self, from: data)
                    self.onMain { complete(.success(pesponse)) }
                } catch let error {
                    print("error = ", error.localizedDescription) //FIXME: - delete
                    self.onMain { complete(.failure(.decodable)) }
                }
            }
        }
    }
    
    func changeLike(postId: Int, userId: Int, complete: @escaping (Result<Post, NetworkServiceError>) -> Void) {
        
        let urlString = Constants.URLs.changeLike
        
        guard let url = URL(string: urlString) else { complete(.failure(.badUrl)); return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PUT"
        let dataSting = "postId=\(postId)&userId=\(userId)"
        urlRequest.httpBody = dataSting.data(using: .utf8)

        taskResume(with: urlRequest) { (data, error) in
            
//            self.typeDebug(data: data)
            
            if let error = error {
                self.onMain { complete(.failure(.network(str: error.localizedDescription))) }
            } else if let data = data {
                do {
                    let decodePost = try JSONDecoder().decode(Post.self, from: data)
                    self.onMain { complete(.success(decodePost)) }
                } catch {
                    self.onMain { complete(.failure(.decodable)) }
                }
            }
        }
    }
    
    //FIXME: - user.php
    func updateProfile(id: Int, name: String, avatar: UIImage?, complete: @escaping (Result<[User], NetworkServiceError>) -> Void) {
        
        let urlString = Constants.URLs.updatePrifile
        
        guard let url = URL(string: urlString) else { complete(.failure(.badUrl)); return }
        let filePathKey = "file"
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
            
//            self.typeDebug(data: data)
            
            if let error = error {
                self.onMain { complete(.failure(.network(str: error.localizedDescription))) }
            } else if let data = data {
                do {
                    let decodeUsers = try JSONDecoder().decode([User].self, from: data)
                    self.onMain { complete(.success(decodeUsers)) }
                } catch {
                    self.onMain { complete(.failure(.decodable)) }
                }
            }
        }
    }
    
    func logIn(login: String, password: String, complete: @escaping (Result<[User], NetworkServiceError>) -> Void) {
        
        let urlString = Constants.URLs.login
        
        guard let url = URL(string: urlString) else { complete(.failure(.badUrl)); return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        let dataSting = "login=\(login)&password=\(password)"
        urlRequest.httpBody = dataSting.data(using: .utf8)
        
        taskResume(with: urlRequest) { (data, error) in
            
            self.typeDebug(data: data)
            
            if let error = error {
                self.onMain { complete(.failure(.network(str: error.localizedDescription))) }
            } else if let data = data {
                do {
                    let decodeUsers = try JSONDecoder().decode([User].self, from: data)
                    self.onMain { complete(.success(decodeUsers)) }
                } catch {
                    self.onMain { complete(.failure(.decodable)) }
                }
            }
        }
    }
    
    //FIXME: - user.php
    func register(name: String, login: String, password: String, avatar: UIImage?, complete: @escaping (Result<[User], NetworkServiceError>) -> Void) {
        
        let urlString = Constants.URLs.register
        
        guard let url = URL(string: urlString) else { complete(.failure(.badUrl)); return }
        let filePathKey = "file"
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
            
//            self.typeDebug(data: data)
            
            if let error = error {
                self.onMain { complete(.failure(.network(str: error.localizedDescription))) }
            } else if let data = data {
                do {
                    let decodeUsers = try JSONDecoder().decode([User].self, from: data)
                    self.onMain { complete(.success(decodeUsers)) }
                } catch {
                    self.onMain { complete(.failure(.decodable)) }
                }
            }
        }
    }
    
    func sendPost(post: SendPost, complete: @escaping (Result<Response, NetworkServiceError>) -> Void) {
        
        
        let urlString = Constants.URLs.sendPost
        
        guard let url = URL(string: urlString) else { complete(.failure(.badUrl)); return }
        let filePathKey = "file"
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
            
//            self.typeDebug(data: data)
            
            if let error = error {
                self.onMain { complete(.failure(.network(str: error.localizedDescription))) }
            } else if let data = data {
                do {
                    let pesponse = try JSONDecoder().decode(Response.self, from: data)
                    self.onMain { complete(.success(pesponse)) }
                } catch {
                    self.onMain { complete(.failure(.decodable)) }
                }
            }
        }
    }
}
