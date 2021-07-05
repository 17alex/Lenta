//
//  MOPost+CoreDataProperties.swift
//  Lenta
//
//  Created by Алексей Алексеев on 27.06.2021.
//
//

import Foundation
import CoreData


extension MOPost {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MOPost> {
        return NSFetchRequest<MOPost>(entityName: "MOPost")
    }

    @NSManaged public var commentsCount: Int16
    @NSManaged public var descr: String
    @NSManaged public var id: Int16
    @NSManaged public var timeInterval: Int32
    @NSManaged public var userId: Int16
    @NSManaged public var viewsCount: Int16
    @NSManaged public var likes: NSSet
    @NSManaged public var photo: MOPhoto?

}

// MARK: Generated accessors for likes
extension MOPost {

    @objc(addLikesObject:)
    @NSManaged public func addToLikes(_ value: MOLike)

    @objc(removeLikesObject:)
    @NSManaged public func removeFromLikes(_ value: MOLike)

    @objc(addLikes:)
    @NSManaged public func addToLikes(_ values: NSSet)

    @objc(removeLikes:)
    @NSManaged public func removeFromLikes(_ values: NSSet)

}

extension MOPost : Identifiable {

}
