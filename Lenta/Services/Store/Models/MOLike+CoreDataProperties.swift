//
//  MOLike+CoreDataProperties.swift
//  Lenta
//
//  Created by Алексей Алексеев on 27.06.2021.
//
//

import Foundation
import CoreData


extension MOLike {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MOLike> {
        return NSFetchRequest<MOLike>(entityName: "MOLike")
    }

    @NSManaged public var userId: Int16
    @NSManaged public var post: MOPost

}

extension MOLike : Identifiable {

}
