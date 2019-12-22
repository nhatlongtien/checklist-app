//
//  ListDetailViewController.swift
//  Checklists
//
//  Created by NGUYENLONGTIEN on 12/10/19.
//  Copyright © 2019 NGUYENLONGTIEN. All rights reserved.
//

import UIKit
var iconNames = ""
protocol ListDetailViewControllerDelegate: class {
    func listDetailViewControllerDidCancel( _ controller: ListDetailViewController)
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist)
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist)
}
class ListDetailViewController: UITableViewController, UITextFieldDelegate, IconPickerViewControllerGelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    weak var delegate: ListDetailViewControllerDelegate?
    var checklistToEdit: Checklist?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        title = "Add list"
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.placeholder = "Name of the list"
        doneBarButton.isEnabled = false
        
        if let list = checklistToEdit{
            title = "Edit checklist"
            textField.text = list.name
            doneBarButton.isEnabled = false
        }
    }
    // MARK: - ACTION
    
    @IBAction func btn_Cancel(_ sender: Any) {
        delegate?.listDetailViewControllerDidCancel(self)
    }
    
    @IBAction func btn_Done(_ sender: Any) {
        if let checklist = checklistToEdit{
            checklist.name = textField.text!
            checklist.iconName = iconNames
            delegate?.listDetailViewController(self, didFinishEditing: checklist)
        }else{
            let checklist = Checklist(name: textField.text!)
            checklist.iconName = iconNames
            delegate?.listDetailViewController(self, didFinishAdding: checklist)
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    //MARK: text fieid delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        if newText.isEmpty{
            doneBarButton.isEnabled = false
        }else{
            doneBarButton.isEnabled = true
        }
        return true
    }
    //MARK:- Icon picker delegate
    func iconPicker(_ picker: IconPickerViewController, didPick iconName: String) {
        iconNames = iconName
        imageView.image = UIImage(named: iconNames)
        doneBarButton.isEnabled = true
        navigationController?.popViewController(animated: true)
    }
    //MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PickIcon"{
            let controller = segue.destination as! IconPickerViewController
            controller.delegate = self
        }
    }

}
