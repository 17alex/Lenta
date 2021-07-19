//
//  NetworkManager.swift
//  Lenta
//
//  Created by Alex on 11.01.2021.
//

import Foundation

enum NetworkServiceError: String, Error {
    case badUrl = "URL error"
    case network = "Network error"
    case decodable = "Decode error"
    case unknown = "Unknown error"
}

protocol NetworkManagerProtocol {
    func login(login: String, password: String, completion: @escaping (Result<[User], NetworkServiceError>) -> Void)
    func register(name: String, login: String, password: String, avatar: Data?,
                  completion: @escaping (Result<[User], NetworkServiceError>) -> Void)
    func getPosts(fromPostId: Int16?, completion: @escaping (Result<Response, NetworkServiceError>) -> Void)
    func sendPost(post: SendPost, completion: @escaping (Result<Response, NetworkServiceError>) -> Void)
    func updateProfile(userId: Int16, name: String, avatar: Data?,
                       completion: @escaping (Result<[User], NetworkServiceError>) -> Void)
    func changeLike(postId: Int16, userId: Int16, completion: @escaping (Result<Post, NetworkServiceError>) -> Void)
    func removePost(postId: Int16, completion: @escaping (Result<Response, NetworkServiceError>) -> Void)
    func loadComments(for postId: Int16, completion: @escaping (Result<ResponseComment, NetworkServiceError>) -> Void)
    func sendComment(_ comment: String, postId: Int16, userId: Int16,
                     completion: @escaping (Result<ResponseComment, NetworkServiceError>) -> Void)
    func loadImage(from urlString: String?, completion: @escaping (Data?) -> Void)
}

final class NetworkManager {

    // MARK: - Init

    init() {
        print("NetworkManager init")
    }

    deinit {
        print("NetworkManager deinit")
    }

    // MARK: - Methods

    private func taskResume(with urlRequest: URLRequest, completion: @escaping (Data?, Error?) -> Void) {
        URLSession.shared.dataTask(with: urlRequest) { data, _, error in
                completion(data, error)
        }.resume()
    }

    private func onMain(_ blok: @escaping () -> Void) {
        DispatchQueue.main.async { blok() }
    }

    private func typeDebug(data: Data?) {
        if let myData = data, let dataString = String(data: myData, encoding: .utf8) {
            print("dataString: " + dataString)
        }
    }
}

// MARK: - NetworkManagerProtocol

extension NetworkManager: NetworkManagerProtocol {

    func loadImage(from urlString: String?, completion: @escaping (Data?) -> Void) {

        guard let urlString = urlString, let url = URL(string: urlString) else {
            onMain { completion(nil) }
            return
        }

        let urlRequest = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)
        URLSession.shared.dataTask(with: urlRequest) { [weak self] data, _, _ in
            guard let self = self else { return }
            if let imageData = data {
                self.onMain { completion(imageData) }
            } else {
                self.onMain { completion(nil) }
            }
        }.resume()
    }

    func sendComment(_ comment: String, postId: Int16, userId: Int16,
                     completion: @escaping (Result<ResponseComment, NetworkServiceError>) -> Void) {

        let urlString = Constants.URLs.sendComment
        guard let url = URL(string: urlString) else { completion(.failure(.badUrl)); return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        let postSting = "comment=\(comment)&postId=\(postId)&userId=\(userId)"
        urlRequest.httpBody = postSting.data(using: .utf8)

        taskResume(with: urlRequest) { [weak self] data, error in
            guard let self = self else { return }

            if error != nil { self.onMain { completion(.failure(.network)) }; return }
            guard let data = data else { self.onMain { completion(.failure(.unknown)) }; return }

            do {
                let responseComment = try JSONDecoder().decode(ResponseComment.self, from: data)
                self.onMain { completion(.success(responseComment)) }
            } catch {
                self.onMain { completion(.failure(.decodable)) }
            }
        }
    }

    func loadComments(for postId: Int16, completion: @escaping (Result<ResponseComment, NetworkServiceError>) -> Void) {

        let urlString = Constants.URLs.getComments
        var components = URLComponents(string: urlString)
        components?.queryItems = [
            URLQueryItem(name: "postId", value: String(postId))
        ]

        guard let url = components?.url else { completion(.failure(.badUrl)); return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"

        taskResume(with: urlRequest) { [weak self] data, error in
            guard let self = self else { return }

            if error != nil { self.onMain { completion(.failure(.network)) }; return }
            guard let data = data else { self.onMain { completion(.failure(.unknown)) }; return }

            do {
                let pesponseComment = try JSONDecoder().decode(ResponseComment.self, from: data)
                self.onMain { completion(.success(pesponseComment)) }
            } catch {
                self.onMain { completion(.failure(.decodable)) }
            }
        }
    }

    func getPosts(fromPostId: Int16? = nil, completion: @escaping (Result<Response, NetworkServiceError>) -> Void) {

        let urlString = Constants.URLs.getPosts
        var components = URLComponents(string: urlString)
        if let fromPostId = fromPostId {
            components?.queryItems = [
                URLQueryItem(name: "fromPostId", value: String(fromPostId))
            ]
        }

        guard let url = components?.url else { completion(.failure(.badUrl)); return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"

        taskResume(with: urlRequest) { [weak self] data, error in
            guard let self = self else { return }

            if error != nil { self.onMain { completion(.failure(.network)) }; return }
            guard let data = data else { self.onMain { completion(.failure(.unknown)) }; return }

            do {
                let pesponse = try JSONDecoder().decode(Response.self, from: data)
                self.onMain { completion(.success(pesponse)) }
            } catch {
                self.onMain { completion(.failure(.decodable)) }
            }
        }
    }

    func removePost(postId: Int16, completion: @escaping (Result<Response, NetworkServiceError>) -> Void) {

        let urlString = Constants.URLs.removePost
        guard let url = URL(string: urlString) else { completion(.failure(.badUrl)); return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        let postSting = "postId=\(postId)"
        urlRequest.httpBody = postSting.data(using: .utf8)

        taskResume(with: urlRequest) { [weak self] data, error in
            guard let self = self else { return }

            if error != nil { self.onMain { completion(.failure(.network)) }; return }
            guard let data = data else { self.onMain { completion(.failure(.unknown)) }; return }

            do {
                let pesponse = try JSONDecoder().decode(Response.self, from: data)
                self.onMain { completion(.success(pesponse)) }
            } catch {
                self.onMain { completion(.failure(.decodable)) }
            }
        }
    }

    func changeLike(postId: Int16, userId: Int16, completion: @escaping (Result<Post, NetworkServiceError>) -> Void) {

        let urlString = Constants.URLs.changeLike
        guard let url = URL(string: urlString) else { completion(.failure(.badUrl)); return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PUT"
        let dataSting = "postId=\(postId)&userId=\(userId)"
        urlRequest.httpBody = dataSting.data(using: .utf8)

        taskResume(with: urlRequest) { [weak self] data, error in
            guard let self = self else { return }

            if error != nil { self.onMain { completion(.failure(.network)) }; return }
            guard let data = data else { self.onMain { completion(.failure(.unknown)) }; return }

            do {
                let decodePost = try JSONDecoder().decode(Post.self, from: data)
                self.onMain { completion(.success(decodePost)) }
            } catch {
                self.onMain { completion(.failure(.decodable)) }
            }
        }
    }

    func updateProfile(userId: Int16, name: String, avatar: Data?,
                       completion: @escaping (Result<[User], NetworkServiceError>) -> Void) {

        let urlString = Constants.URLs.updatePrifile
        guard let url = URL(string: urlString) else { completion(.failure(.badUrl)); return }
        let filePathKey = "file"
        let boundary = "Boundary-\(UUID().uuidString)"
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        var parameters: [String: String] = [:]
        parameters["id"] = String(userId)
        parameters["name"] = name

        for (key, value) in parameters {
            body.append(Data("--\(boundary)\r\n".utf8))
            body.append(Data("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".utf8))
            body.append(Data("\(value)\r\n".utf8))
        }

        if let imageData = avatar {
            let filename = String(Int(Date().timeIntervalSince1970)) + ".jpg"
            let mimetype = "image/jpg"
            body.append(Data("--\(boundary)\r\n".utf8))
            body.append(
                Data("Content-Disposition: form-data; name=\"\(filePathKey)\"; filename=\"\(filename)\"\r\n".utf8))
            body.append(Data("Content-Type: \(mimetype)\r\n\r\n".utf8))
            body.append(imageData)
            body.append(Data("\r\n".utf8))
            body.append(Data("--\(boundary)--\r\n".utf8))
        }

        urlRequest.httpBody = body
        taskResume(with: urlRequest) { [weak self] data, error in
            guard let self = self else { return }

            if error != nil { self.onMain { completion(.failure(.network)) }; return }
            guard let data = data else { self.onMain { completion(.failure(.unknown)) }; return }

            do {
                let decodeUsers = try JSONDecoder().decode([User].self, from: data)
                self.onMain { completion(.success(decodeUsers)) }
            } catch {
                self.onMain { completion(.failure(.decodable)) }
            }
        }
    }

    func login(login: String, password: String, completion: @escaping (Result<[User], NetworkServiceError>) -> Void) {

        let urlString = Constants.URLs.login
        guard let url = URL(string: urlString) else { completion(.failure(.badUrl)); return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        let dataSting = "login=\(login)&password=\(password)"
        urlRequest.httpBody = dataSting.data(using: .utf8)

        taskResume(with: urlRequest) { [weak self] data, error in
            guard let self = self else { return }

            if error != nil { self.onMain { completion(.failure(.network)) }; return }
            guard let data = data else { self.onMain { completion(.failure(.unknown)) }; return }

            do {
                let decodeUsers = try JSONDecoder().decode([User].self, from: data)
                self.onMain { completion(.success(decodeUsers)) }
            } catch {
                self.onMain { completion(.failure(.decodable)) }
            }
        }
    }

    func register(name: String, login: String, password: String, avatar: Data?,
                  completion: @escaping (Result<[User], NetworkServiceError>) -> Void) {

        let urlString = Constants.URLs.register
        guard let url = URL(string: urlString) else { completion(.failure(.badUrl)); return }
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

        if let imageData = avatar {
            let filename = String(Int(Date().timeIntervalSince1970)) + ".jpg"
            let mimetype = "image/jpg"
            body.append(Data("--\(boundary)\r\n".utf8))
            body.append(
                Data("Content-Disposition: form-data; name=\"\(filePathKey)\"; filename=\"\(filename)\"\r\n".utf8))
            body.append(Data("Content-Type: \(mimetype)\r\n\r\n".utf8))
            body.append(imageData)
            body.append(Data("\r\n".utf8))
            body.append(Data("--\(boundary)--\r\n".utf8))
        }

        urlRequest.httpBody = body
        taskResume(with: urlRequest) { [weak self] data, error in
            guard let self = self else { return }

            if error != nil { self.onMain { completion(.failure(.network)) }; return }
            guard let data = data else { self.onMain { completion(.failure(.unknown)) }; return }

            do {
                let decodeUsers = try JSONDecoder().decode([User].self, from: data)
                self.onMain { completion(.success(decodeUsers)) }
            } catch {
                self.onMain { completion(.failure(.decodable)) }
            }
        }
    }

    func sendPost(post: SendPost, completion: @escaping (Result<Response, NetworkServiceError>) -> Void) {

        let urlString = Constants.URLs.sendPost
        guard let url = URL(string: urlString) else { completion(.failure(.badUrl)); return }
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

        if let imageData = post.imageData {
            let filename = String(Int(Date().timeIntervalSince1970)) + ".jpg"
            let mimetype = "image/jpg"
            body.append(Data("--\(boundary)\r\n".utf8))
            body.append(
                Data("Content-Disposition: form-data; name=\"\(filePathKey)\"; filename=\"\(filename)\"\r\n".utf8))
            body.append(Data("Content-Type: \(mimetype)\r\n\r\n".utf8))
            body.append(imageData)
            body.append(Data("\r\n".utf8))
            body.append(Data("--\(boundary)--\r\n".utf8))
        }

        urlRequest.httpBody = body
        taskResume(with: urlRequest) { [weak self] data, error in
            guard let self = self else { return }

            if error != nil { self.onMain { completion(.failure(.network)) }; return }
            guard let data = data else { self.onMain { completion(.failure(.unknown)) }; return }

            do {
                let response = try JSONDecoder().decode(Response.self, from: data)
                self.onMain { completion(.success(response)) }
            } catch {
                self.onMain { completion(.failure(.decodable)) }
            }
        }
    }
}
