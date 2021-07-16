//
//  MOUser+CoreDataProperties.swift
//  Lenta
//
//  Created by Алексей Алексеев on 27.06.2021.
//
//

import Foundation
import CoreData

extension MOUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MOUser> {
        return NSFetchRequest<MOUser>(entityName: "MOUser")
    }

    @NSManaged public var avatar: String
    @NSManaged public var dateRegister: Int32
    @NSManaged public var id: Int16
    @NSManaged public var name: String
    @NSManaged public var postsCount: Int16

}

extension MOUser: Identifiable {

}
