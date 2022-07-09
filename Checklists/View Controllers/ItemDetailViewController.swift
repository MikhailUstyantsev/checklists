//
//  AddItemViewController.swift
//  Checklists
//
//  Created by Михаил on 25.06.2022.
//

import UIKit


//Think of the delegate protocol as a contract between screen B — in this case the Add Item View Controller — and any screens that wish to use it.

//The first method is for when the user presses Cancel, the second is for when they press Done


//It is customary for the delegate methods to have a reference to their owner as the first (or only) parameter
protocol ItemDetailViewControllerDelegate: AnyObject {
    
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem)
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem)
}



class ItemDetailViewController: UITableViewController, UITextFieldDelegate {

    
    @IBOutlet var shouldRemindSwitch: UISwitch!
    
    @IBOutlet var datePicker: UIDatePicker!
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    weak var delegate: ItemDetailViewControllerDelegate?
    
    var itemToEdit: ChecklistItem?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        
        if let item = itemToEdit {
            title = "Edit Item"
            textField.text = item.text
            doneBarButton.isEnabled = true
            shouldRemindSwitch.isOn = item.shouldRemind
            datePicker.date = item.dueDate
        }
    }

    
    @IBAction func shouldRemindToggled(_ switchControl: UISwitch) {
        textField.resignFirstResponder()
        
        if switchControl.isOn {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound]) { _, _ in
//                do nothing
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    
    // MARK: - Table view Delegates
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // MARK: - Actions
    @IBAction func cancel() {
//        When the user taps the Cancel button, you send the itemDetailViewControllerDidCancel(_:) message back to the delegate.
        delegate?.itemDetailViewControllerDidCancel(self)
//        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func done() {
        if let item = itemToEdit {
            item.text = textField.text!
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = datePicker.date
            item.scheduleNotification()
            delegate?.itemDetailViewController(self, didFinishEditing: item)
        } else {
            let item = ChecklistItem()
            item.text = textField.text!
            item.checked = false
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = datePicker.date
            item.scheduleNotification()
            delegate?.itemDetailViewController(self, didFinishAdding: item)
        }
    }
    
//    MARK: - Text Field Delegates
   
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
      replacementString string: String) -> Bool {
      let oldText = textField.text!
//          we converted the NSRange value to a Swift-understandable Range value
      let stringRange = Range(range, in: oldText)!
      let newText = oldText.replacingCharacters(in: stringRange, with: string)
      doneBarButton.isEnabled = !newText.isEmpty
      return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false
        return true
    }
    
    
    
    
}
