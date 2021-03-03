//
//  CurrentUserModel.swift
//  Lenta
//
//  Created by Alex on 03.03.2021.
//

import Foundation

struct CurrentUserModel {
    let name: String
    let postsCount: String
    let dateRegister: String
    let avatar: String
    
    init?(currentUser: CurrentUser?) {
        guard let currentUser = currentUser else { return nil }
        name = currentUser.name
        postsCount = String(describing: currentUser.postsCount)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.locale = Locale(identifier: "en_EN")
        dateRegister = dateFormatter.string(from: Date(timeIntervalSince1970: currentUser.dateRegister))
        avatar = currentUser.avatar.isEmpty ? "" : "https://monsterok.ru/lenta/avatars/" + currentUser.avatar
    }
}
