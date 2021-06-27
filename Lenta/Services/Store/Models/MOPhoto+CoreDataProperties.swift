//
//  MOPhoto+CoreDataProperties.swift
//  Lenta
//
//  Created by Алексей Алексеев on 27.06.2021.
//
//

import Foundation
import CoreData


extension MOPhoto {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MOPhoto> {
        return NSFetchRequest<MOPhoto>(entityName: "MOPhoto")
    }

    @NSManaged public var height: Int16
    @NSManaged public var name: String
    @NSManaged public var width: Int16
    @NSManaged public var post: MOPost

}

extension MOPhoto : Identifiable {

}
