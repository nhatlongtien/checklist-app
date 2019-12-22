//
//  AddItemTableViewController.swift
//  Checklists
//
//  Created by NGUYENLONGTIEN on 12/7/19.
//  Copyright © 2019 NGUYENLONGTIEN. All rights reserved.
//

import UIKit
import UserNotifications

protocol ItemDetailViewControllerDelegate: class {
  func addItemViewControllerDidCancel(_ controller: ItemDetailViewController)
  func addItemViewController(_ controller: ItemDetailViewController,
didFinishAdding item: checkListItem)
    func addItemViewController(_ controller: ItemDetailViewController, didFinishEditing item: checkListItem)
}
class ItemDetailViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var dueDateLable: UILabel!
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet var datePickerCell: UITableViewCell!
    weak var delegate: ItemDetailViewControllerDelegate?
    var itemToEdit: checkListItem?
    var dueDate = Date()
    var datePickerVisible = false
    override func viewDidLoad() {
        super.viewDidLoad()
       title = "Add Item"
        navigationItem.largeTitleDisplayMode = .never
        
        textField.placeholder = "Name of the Item"
        textField.font = UIFont.systemFont(ofSize: 17)
        doneBarButton.isEnabled = false
        
        if let item = itemToEdit{
            title = "Edit Item"
            textField.text = item.text
            doneBarButton.isEnabled = true
            shouldRemindSwitch.isOn = item.shouldRemind
            dueDate = item.dueDate
        }
        updateDueDateLable()
    }
    
    @IBAction func btn_Cancel() {
        //navigationController?.popViewController(animated: true)
         delegate?.addItemViewControllerDidCancel(self)
    }
    
    @IBAction func shouldRemindToggled(_ sender: Any) {
        if shouldRemindSwitch.isOn{
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
                // do something
            }
        }
    }
    @IBAction func btn_Done(_ sender: Any) {
        if let item = itemToEdit{
            item.text = textField.text!
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = dueDate
            item.scheduleNotification()
            delegate?.addItemViewController(self, didFinishEditing: item)
        }else{
            let item = checkListItem()
            item.text = textField.text!
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = dueDate
            item.scheduleNotification()
            delegate?.addItemViewController(self, didFinishAdding: item)
        }
        
    }
    @IBAction func dateChanged(_ sender: Any) {
        dueDate = datePicker.date
        updateDueDateLable()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1 && indexPath.row == 1{
            return indexPath
        }else{
           return nil
        }
    }
    // MARK:- Table View Delegates
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 && indexPath.row == 2{
            return datePickerCell
        }else{
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 && datePickerVisible{
            return 3
        }else{
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 2 {
            return 217
        }else{
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        textField.resignFirstResponder()
        if indexPath.section == 1 && indexPath.row == 1 {
            if !datePickerVisible{
               showDatePicker()
            }else{
                hideDatePicker()
            }
        }
    }
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        var newIndexPath = indexPath
        if indexPath.section == 1 && indexPath.row == 2{
            newIndexPath = IndexPath(row: 0, section: indexPath.section)
        }
        return super.tableView(tableView, indentationLevelForRowAt: newIndexPath)
    }
    
    // MARK:- Text Field Delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in:oldText)!
        let newText = oldText.replacingCharacters(in: stringRange,
                                                  with: string)
        if newText.isEmpty {
            doneBarButton.isEnabled = false
        }else{
            doneBarButton.isEnabled = true
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        hideDatePicker()
    }
    // MARK:- helper methods
    func updateDueDateLable(){
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        dueDateLable.text = formatter.string(from: dueDate)
    }
    func showDatePicker(){
        datePickerVisible = true
        let indexPathDatePicker = IndexPath(row: 2, section: 1)
        tableView.insertRows(at: [indexPathDatePicker], with: UITableView.RowAnimation.fade)
        datePicker.setDate(dueDate, animated: false)
        dueDateLable.textColor = dueDateLable.tintColor
    }
    func hideDatePicker(){
        if datePickerVisible{
            datePickerVisible = false
            let indexPathDatePicker = IndexPath(row: 2, section: 1)
            tableView.deleteRows(at: [indexPathDatePicker], with: UITableView.RowAnimation.fade)
            dueDateLable.textColor = UIColor.black
        }
    }
}
