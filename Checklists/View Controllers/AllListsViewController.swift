//
//  AllListsViewController.swift
//  Checklists
//
//  Created by Михаил on 28.06.2022.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate, UINavigationControllerDelegate {

    var dataModel: DataModel!
    
    let cellIdentifier = "ChecklistCell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
//register the cell identifier with the underlying table view, so that the table view knows which cell class should be used to create a new table view cell instance when a dequeue request comes in with that cell identifier
       
//        print("Documents folder is \(documentDirectory())")
//        print("Data file path is \(dataFilePath())")
       
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        navigationController?.delegate = self

        let index = dataModel.indexOfSelectedChecklist
        if index >= 0 && index < dataModel.lists.count {
            let checklist = dataModel.lists[index]
            performSegue(withIdentifier: "ShowChecklist", sender: checklist)
        }
    }
    
    
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        dataModel.lists.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataModel.lists.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        Get cell
        let cell: UITableViewCell!
        if let tmp = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            cell = tmp
        } else {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
        let checklist = dataModel.lists[indexPath.row]
        cell.textLabel!.text = checklist.name
        let count = checklist.countUncheckedItems()
        if checklist.items.count == 0 {
            cell.detailTextLabel!.text = "(No Items)"
        } else {
    cell.detailTextLabel!.text = count == 0 ? "All Done" : "\(checklist.countUncheckedItems()) Remaining"
        }
        cell.accessoryType = .detailDisclosureButton
        cell.imageView!.image = UIImage(named: checklist.iconName)
        return cell
    }
 
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataModel.indexOfSelectedChecklist = indexPath.row
        let checklist = dataModel.lists[indexPath.row]
        performSegue(withIdentifier: "ShowChecklist", sender: checklist)
    }
   
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let controller = storyboard!.instantiateViewController(withIdentifier: "ListDetailViewController") as! ListDetailViewController
        controller.delegate = self
        
        let checklist = dataModel.lists[indexPath.row]
        controller.checklistToEdit = checklist
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChecklist" {
            let destinationController = segue.destination as! CheckListViewController
            destinationController.checklist = sender as? Checklist
        } else if segue.identifier == "AddChecklist" {
            let destinationController = segue.destination as! ListDetailViewController
            destinationController.delegate = self
        }
    }
    
//    MARK: - Navigation Controller Delegates
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
//        Was the back button tapped?
/*
 If you use ==, you’re checking whether two variables have the same value.
 With === you’re checking whether two variables refer to the exact same object
 */
        if viewController === self {
            dataModel.indexOfSelectedChecklist = -1
        }
    }
    
    
//MARK: - List Detail View Controller Delegates
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist) {
       
        dataModel.lists.append(checklist)
        dataModel.sortChecklists()
        tableView.reloadData()
        
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist) {
        dataModel.sortChecklists()
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    
    
    
    
    
    
    
}
