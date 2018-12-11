//
//  SNSID+CoreDataProperties.swift
//  MID
//
//  Created by 江宇揚 on 2018/12/11.
//  Copyright © 2018 Jiang Yuyang. All rights reserved.
//
//

import Foundation
import CoreData


extension SNSID {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SNSID> {
        return NSFetchRequest<SNSID>(entityName: "SNSID")
    }

    @NSManaged public var name: String?

}
