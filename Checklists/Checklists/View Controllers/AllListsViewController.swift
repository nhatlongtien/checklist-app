//
//  AllListsViewController.swift
//  Checklists
//
//  Created by NGUYENLONGTIEN on 12/9/19.
//  Copyright © 2019 NGUYENLONGTIEN. All rights reserved.
//

import UIKit
//var lists = [Checklist]()

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate{
let cellIdentifier = "ChecklistCell"
    var dataModel: DataModel!
    override func viewWillAppear(_ animated: Bool) {
        dataModel.saveChecklists()
        tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Checklists"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataModel.lists.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get cell
        let cell =  UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: cellIdentifier)
        
        //update cell infomation
       
        cell.textLabel?.text = dataModel.lists[indexPath.row].name
        cell.accessoryType = .detailDisclosureButton
        let count = dataModel.lists[indexPath.row].countUncheckedItem()
        if dataModel.lists[indexPath.row].items.count == 0 {
            cell.detailTextLabel?.text = "(No Items)"
        }else{
            cell.detailTextLabel?.text = count == 0 ? "All Done" : "\(count) Remaining"
        }
        cell.imageView?.image = UIImage(named: dataModel.lists[indexPath.row].iconName)
        return cell
    }
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //checklist = lists[indexPath.row]

        let checklist = dataModel.lists[indexPath.row]
        performSegue(withIdentifier: "ShowChecklist", sender: checklist)
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        dataModel.lists.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: UITableView.RowAnimation.automatic)
        dataModel.saveChecklists()
    }
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "ListDetailViewController") as! ListDetailViewController
        controller.delegate = self
        controller.checklistToEdit = dataModel.lists[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
        dataModel.saveChecklists()
    }
    // MARK: - ListDetailViewControllerDelegate
       func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
           navigationController?.popViewController(animated: true)
       }
       
       func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist) {
        let newRowIndex = dataModel.lists.count
        dataModel.lists.append(checklist)
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: UITableView.RowAnimation.automatic)
           navigationController?.popViewController(animated: true)
        dataModel.saveChecklists()
       }
       
       func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist) {
        if let index = dataModel.lists.index(of: checklist){
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath){
                cell.textLabel?.text = checklist.name
            }
        }
           navigationController?.popViewController(animated: true)
        dataModel.saveChecklists()
       }
       
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChecklist"{
            let controller = segue.destination as! CheckListViewController
            
            controller.checklist = sender as? Checklist
        }else if segue.identifier == "AddList"{
            let controller = segue.destination as! ListDetailViewController
            controller.delegate = self
        }
        
    }
}
