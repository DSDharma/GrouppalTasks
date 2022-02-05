//
//  TasksTVCell.swift
//  Tasks
//
//  Created by Dharma on 05/02/22.
//

import UIKit

class TasksTVCell: UITableViewCell {
    
    @IBOutlet weak var textField: UITextField!
    
    var object: ROTasks? = nil
    var delegate: TasksDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        self.selectionStyle = .none
        self.textField.delegate = self
    }
    
    func setContent(object: ROTasks,
                    displayMode: TasksDisplayMode,
                    target: ViewController? = nil) {
        
        self.delegate = target
        self.object = object
        
        if object.isEmptyTask {
            self.accessoryType = .none
        }else{
            if displayMode == .viewMode && object.isSelected {
                self.accessoryType = .checkmark
            }else{
                if displayMode == .editMode {
                    self.accessoryType = .disclosureIndicator
                }else{
                    self.accessoryType = .none
                }
            }
        }
        self.textField.placeholder = object.isEmptyTask ? "Create a New Task..." : ""
        self.textField.text = object.taskTitle
        self.textField.isEnabled = object.isEmptyTask ? true : false
    }
}

extension TasksTVCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        print(textField.text as Any)
        if textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            return
        }
        if self.object == nil
            || self.object?.isEmptyTask ?? false{
            self.delegate?.didNewTaskCreated?(title: textField.text ?? "")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
