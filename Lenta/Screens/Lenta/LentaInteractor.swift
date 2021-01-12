//
//  LentaInteractor.swift
//  Lenta
//
//  Created by Alex on 11.01.2021.
//

import Foundation

protocol LentaInteractorInput {
    var posts: [Post] { get }
    var postCount: Int { get }
    func loadPosts()
}

class LentaInteractor {
    
    unowned let presenter: LentaInteractorOutput
    var networkManager: NetworkManagerProtocol!
    
    init(presenter: LentaInteractorOutput) {
        print("LentaInteractor init")
        self.presenter = presenter
    }
    
    deinit { print("LentaInteractor deinit") }
    
    var posts: [Post] = [
//        Post(title: "title 1, title ...;", name: "name 1;", description: "description 1;", imageUrl: nil),
//        Post(title: "title 2, titit tttt ii  ll  er.;", name: "name 2, name 2, name 2, name 2;", description: "desc description 2, description 2, description 2, description 2, description 2, description 2, description 2, description 2;", imageUrl: nil),
//        Post(title: "title 3 .. rerewewsdfdfgdfg sdf gsdfg sdfg sdfgs df;", name: "name 3, name 3;", description: "descrip 3, description 3, description 3, description 3, description 3, description 3, description 3, description 3, description 3, description 3, description 3, description 3, description 3...;", imageUrl: nil),
//        Post(title: "title 4 444   455556567456 4567 356 3 35 673567 3567 3567;", name: "name 4, name 4;", description: "description 4, description 4, description 4;", imageUrl: nil),
//        Post(title: "title 5 55 5555 555;", name: "name 5, name 5, name 5;", description: "description 5, description 5;", imageUrl: nil),
//        Post(title: "title 6 7777 6666 7776 6 67 767;", name: "name 6 ..;", description: "description 5, description 5, description 5, description 5 ...;", imageUrl: nil),
//        Post(title: nil, name: "name 6 ..;", description: "description 5, description 5, description 5, description 5 ...;", imageUrl: nil),
//        Post(title: "title 8;", name: nil, description: "description 5, description 5, description 5, description 5 ...;", imageUrl: nil),
//        Post(title: "title 9;", name: "name 6 ..;", description: nil, imageUrl: nil)
    ]
    
    var postCount: Int {
        posts.count
    }
}

extension LentaInteractor: LentaInteractorInput {
    
    func loadPosts() {
        networkManager.getPosts { (response) in
            switch response {
            case .failure(let error):
                print("error: \(error)")
            case .success(let posts):
                self.posts = posts
                self.presenter.postsDidload()
            }
        }
    }
}
