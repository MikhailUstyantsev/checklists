//
//  ViewController.swift
//  Checklists
//
//  Created by Михаил on 23.06.2022.
//

import UIKit

class CheckListViewController: UITableViewController, ItemDetailViewControllerDelegate {
  
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
/*
 When you start the app there are 5 items in the array and 5 rows on the screen. Computers start counting at 0, so the existing rows have indexes 0, 1, 2, 3 and 4. To add the new row to the end of the array, the index for that new row must be 5.
 In other words, when you add a row to the end of an array, the index for the new row is always equal to the number of items currently in the array.
 */
        let newRowIndex = checklist.items.count
        checklist.items.append(item)
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        navigationController?.popViewController(animated: true)
       
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        if let index = checklist.items.firstIndex(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        navigationController?.popViewController(animated: true)
       
    }
    
    
    
    
    
    var checklist: Checklist!
    
    var items = [ChecklistItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = checklist.name
        navigationItem.largeTitleDisplayMode = .never
        // Do any additional setup after loading the view.
       
        
//        print("Documents folder is \(documentDirectory())")
//        print("Data file path is \(dataFilePath())")
     
    }

    
//    MARK: - Actions
   
    
    
// MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        
        let item = checklist.items[indexPath.row]
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        
        return cell
    }
    
    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
        let label = cell.viewWithTag(1001) as! UILabel
        if item.checked {
            label.text = "√"
          } else {
              label.text = ""
        }
    }
    
    func configureText (for cell: UITableViewCell, with item: ChecklistItem){
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
//        label.text = "\(item.itemID): \(item.text)"
    }
    
//    MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" {
            let destinationController = segue.destination as! ItemDetailViewController
            destinationController.delegate = self
        } else if segue.identifier == "EditItem" {
            let destinationController = segue.destination as!ItemDetailViewController
            destinationController.delegate = self
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                destinationController.itemToEdit = checklist.items[indexPath.row]
            }
        }
    }
    
//    MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = checklist.items[indexPath.row]
            item.checked.toggle()
            configureCheckmark(for: cell, with: item)
           }
        tableView.deselectRow(at: indexPath, animated: true)
       
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        All you have to do is:
//        1. Remove the item from the data model.
//        2. Delete the corresponding row from the table view.
        checklist.items.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    
    }

    
    
    
    
    
    
    
    
    
}

