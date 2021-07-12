//
//  Constants.swift
//  Lenta
//
//  Created by Алексей Алексеев on 26.06.2021.
//

import UIKit

enum Constants {
    enum URLs {
        static let getComments      = "https://monsterok.ru/lenta/getComments.php"
        static let getPosts         = "https://monsterok.ru/lenta/getPosts.php"
        static let sendComment      = "https://monsterok.ru/lenta/addComment.php"
        static let removePost       = "https://monsterok.ru/lenta/removePost.php"
        static let changeLike       = "https://monsterok.ru/lenta/changeLike.php"
        static let login            = "https://monsterok.ru/lenta/login.php"
        static let sendPost         = "https://monsterok.ru/lenta/addPost.php"
        static let register         = "https://monsterok.ru/lenta/register.php"
        static let updatePrifile    = "https://monsterok.ru/lenta/updatePrifile.php"
        static let avatarsPath      = "https://monsterok.ru/lenta/avatars/"
        static let imagesPath       = "https://monsterok.ru/lenta/images/"
    }

    enum Colors {
        static let active = #colorLiteral(red: 0, green: 0.4773686528, blue: 0.8912271857, alpha: 1)
        static let deActive = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        static let bgTable = #colorLiteral(red: 0.1367115593, green: 0.5836390616, blue: 0.6736763277, alpha: 1)
    }
}
