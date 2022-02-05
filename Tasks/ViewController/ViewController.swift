//
//  ViewController.swift
//  Tasks
//
//  Created by Dharma on 05/02/22.
//

import UIKit

@objc protocol TasksDelegate{
    @objc optional func didNewTaskCreated(title: String)
    @objc optional func didTaskEdited()
}

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var displayMode: TasksDisplayMode = .viewMode
    var tasksList: [ROTasks] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.setupUI()
        self.reloadTasksData()
    }
    
    func setupUI() {
        let rightButton = UIBarButtonItem(title: "Edit", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.showEditing))
        self.navigationItem.rightBarButtonItem = rightButton
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.allowsSelectionDuringEditing = true
    }
    
    @objc func showEditing() {
        self.view.endEditing(true)
        
        if self.tableView.isEditing {
            self.tableView.isEditing = false
            self.navigationItem.rightBarButtonItem?.title = "Edit"
            self.displayMode = .viewMode
        }else{
            self.tableView.isEditing = true
            self.navigationItem.rightBarButtonItem?.title = "Done"
            self.displayMode = .editMode
        }
        
        self.tableView.reloadData()
    }
    
    /// reload task data
    func reloadTasksData() {
        self.tasksList = RMTasks.shared.getAllTasks()
        self.addNewTask()
    }
    
    /// add new task at first always
    func addNewTask() {
        let object = ROTasks.init()
        object.isEmptyTask = true
        self.tasksList.insert(object, at: 0)
        
        self.tableView.reloadData()
    }
    
    /// Navigate to edit task controller
    func pushToEditTask(object: ROTasks) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditTaskVC") as? EditTaskVC{
            vc.object = object
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasksList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TasksTVCell
        if indexPath.row < self.tasksList.count{
            cell.setContent(object: self.tasksList[indexPath.row],
                            displayMode: self.displayMode,
                            target: self)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < self.tasksList.count{
            if self.displayMode == .viewMode {
                RMTasks.shared.updateTaskSelectionStatus(object: self.tasksList[indexPath.row])
                self.reloadTasksData()
            }else{
                self.pushToEditTask(object: self.tasksList[indexPath.row])
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Tasks"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = UIColor.black
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        header.textLabel?.frame = CGRect.init(origin: CGPoint.init(x: 20.0, y: 0.0), size:header.bounds.size)
        header.textLabel?.textAlignment = .left
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if indexPath.row < self.tasksList.count {
                if self.tasksList[indexPath.row].isEmptyTask {
                    return
                }
                RMTasks.shared.deleteTask(object: self.tasksList[indexPath.row])
                self.reloadTasksData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            self.tableView.dataSource?.tableView!(self.tableView, commit: .delete, forRowAt: indexPath)
            return
        }
        deleteButton.backgroundColor = UIColor.black
        return [deleteButton]
    }
}

extension ViewController: TasksDelegate {
    
    func didNewTaskCreated(title: String) {
        let object: ROTasks = ROTasks.init()
        object.taskTitle = title
        RMTasks.shared.addTask(object: object)
        
        self.reloadTasksData()
    }
    
    func didTaskEdited() {
        self.reloadTasksData()
    }
}

enum TasksDisplayMode {
    case viewMode /// by defualt
    case editMode
}


