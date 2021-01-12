//
//  NetworkManager.swift
//  Lenta
//
//  Created by Alex on 11.01.2021.
//

import Foundation

protocol NetworkManagerProtocol {
    
    func getPosts(complete: @escaping (Result<[Post], Error>) -> Void)
}

class NetworkManager {
    
    private func taskResume(with url: URL, complete: @escaping (Data?, Error?) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, _, error) in
                complete(data, error)
        }.resume()
    }
    
    private func onMain(_ blok: @escaping () -> Void) {
        DispatchQueue.main.async {
            blok()
        }
    }
}

extension NetworkManager: NetworkManagerProtocol {
    
    func getPosts(complete: @escaping (Result<[Post], Error>) -> Void) {
        let url = URL(string: "https://monsterok.ru/lenta/getPosts.php")!
        taskResume(with: url) { data, error in
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
}
