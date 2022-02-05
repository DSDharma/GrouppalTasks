//
//  RMTasks.swift
//  Tasks
//
//  Created by Dharma on 05/02/22.
//

import RealmSwift

class RMTasks: NSObject {
    
    static let shared = RMTasks()
    private let realm = try! Realm()
    
    private override init() { }
    
    func addTask(object: ROTasks) {
        try! self.realm.write {
            self.realm.add(object)
        }
    }
    
    func updateTask(object: ROTasks,
                    title: String) {
        try! self.realm.write {
            object.taskTitle = title
        }
    }
    
    func updateTaskSelectionStatus(object: ROTasks) {
        self.clearAllTaskSelection()
        try! self.realm.write {
            object.isSelected = true
        }
    }
    
    func clearAllTaskSelection(){
        let tasks = self.getAllTasks()
        tasks.forEach { object in
            try! self.realm.write {
                object.isSelected = false
            }
        }
    }
    
    func getAllTasks() -> [ROTasks] {
        return self.realm.objects(ROTasks.self).toArray(ofType: ROTasks.self)
    }
    
    func deleteTask(object: ROTasks) {
        try! self.realm.write {
            self.realm.delete(object)
        }
    }
}

extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        let array = Array(self) as! [T]
        return array
    }
}
