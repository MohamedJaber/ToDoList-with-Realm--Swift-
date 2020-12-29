//
//  ItemR.swift
//  ToDoList
//
//  Created by Mohamed Jaber on 09/12/2020.
//

import Foundation
import RealmSwift

class ItemsR: Object {
    @objc dynamic var title: String=""
    @objc dynamic var done: Bool=false
    @objc dynamic var dateCreated: Date?
    var parentCategory=LinkingObjects(fromType: CategoryR.self, property: "items")
}
