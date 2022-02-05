//
//  EditTaskVC.swift
//  Tasks
//
//  Created by Dharma on 05/02/22.
//

import UIKit

class EditTaskVC: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    
    var object: ROTasks? = nil
    var delegate: TasksDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.textField.text = object?.taskTitle ?? ""
        self.textField.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.view.endEditing(true)
        self.delegate?.didTaskEdited?()
    }
}


extension EditTaskVC: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if self.object != nil {
            RMTasks.shared.updateTask(object: self.object!,
                                      title: textField.text ?? "")
            self.delegate?.didTaskEdited?()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
