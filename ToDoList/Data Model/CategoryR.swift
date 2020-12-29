//
//  CategoryR.swift
//  ToDoList
//
//  Created by Mohamed Jaber on 09/12/2020.
//

import Foundation
import RealmSwift

class CategoryR: Object {
    @objc dynamic var name: String=""//We used dynamic to monitor the varible while app running (runtime)
    @objc dynamic var color: String=""
    let items=List<ItemsR>()
}
