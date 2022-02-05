//
//  ROTasks.swift
//  Tasks
//
//  Created by Dharma on 05/02/22.
//

import RealmSwift

class ROTasks: Object, Codable {
    @objc dynamic var taskTitle: String = ""
    @objc dynamic var isSelected: Bool = false
    @objc dynamic var isEmptyTask: Bool = false
}
