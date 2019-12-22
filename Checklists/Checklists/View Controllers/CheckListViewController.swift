//
//  ViewController.swift
//  Checklists
//
//  Created by NGUYENLONGTIEN on 12/4/19.
//  Copyright © 2019 NGUYENLONGTIEN. All rights reserved.
//

import UIKit
//var items:Array<checkListItem> = [checkListItem]()

class CheckListViewController: UITableViewController ,ItemDetailViewControllerDelegate{
    
    var checklist:Checklist!
    override func viewWillAppear(_ animated: Bool) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = checklist.name
        navigationItem.largeTitleDisplayMode = .never
        tableView.dataSource = self
        //loadChecklistItems()
        
        //print("Documents folder is \(documentsDirectory())")
        //print("data file path is:\(dataFilePath())")
    }
    
    // MARK:- Actions
    func configureCheckMark(for cell: UITableViewCell, with item: checkListItem){
        let label = cell.viewWithTag(1001) as! UILabel
        if item.checked{
            label.text = "√"
        }else{
            label.text = ""
        }
    }
    // MARK:- Table view Data Source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "checkList", for: indexPath)
        let lable = cell.viewWithTag(1000) as! UILabel
        lable.text = "\(checklist.items[indexPath.row].text)"
        configureCheckMark(for: cell, with: checklist.items[indexPath.row])
        return cell
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        checklist.items.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: UITableView.RowAnimation.automatic)
    }
    // MARK:- Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath){
            let item = checklist.items[indexPath.row]
            item.toggleChecked()
            configureCheckMark(for: cell, with: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
       // dataModel.saveChecklists()
        //saveChecklistItems()
    }
    // MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem"{
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
        }else if segue.identifier == "EditItem"{
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell){
                controller.itemToEdit = checklist.items[indexPath.row]
            }
        }
    }
    
    // MARK:- Add Item ViewController Delegates
    func addItemViewControllerDidCancel(_ controller: ItemDetailViewController) {
      navigationController?.popViewController(animated:true)
    }
    
    func addItemViewController(_ controller: ItemDetailViewController, didFinishAdding item: checkListItem) {
        let newRowIndex = checklist.items.count
        checklist.items.append(item)
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: UITableView.RowAnimation.automatic)
        navigationController?.popViewController(animated: true)
        //saveChecklistItems()
        
    }
    func addItemViewController(_ controller: ItemDetailViewController, didFinishEditing item: checkListItem) {
        if let index = checklist.items.index(of: item){
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath){
                let label = cell.viewWithTag(1000) as! UILabel
                label.text = item.text
            }
        }
        navigationController?.popViewController(animated: true)
        //saveChecklistItems()
    }
}



