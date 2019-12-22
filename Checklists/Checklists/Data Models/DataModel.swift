//
//  DataModel.swift
//  Checklists
//
//  Created by NGUYENLONGTIEN on 12/11/19.
//  Copyright © 2019 NGUYENLONGTIEN. All rights reserved.
//

import Foundation
class DataModel {
  var lists = [Checklist]()
  
  init() {
    loadChecklists()
  }
    class func nextChecklistItemID() -> Int {
      let userDefaults = UserDefaults.standard
      let itemID = userDefaults.integer(forKey: "ChecklistItemID")
      userDefaults.set(itemID + 1, forKey: "ChecklistItemID")
      userDefaults.synchronize()
      return itemID
    }
  
  func documentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
  }
  
  func dataFilePath() -> URL {
    return documentsDirectory().appendingPathComponent(
      "Checklists.plist")
  }
  
  func saveChecklists() {
    let encoder = PropertyListEncoder()
    do {
      let data = try encoder.encode(lists)
      try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
        print("save file thanh cong ----")
    } catch {
      print("Error encoding item array: \(error.localizedDescription)")
    }
  }
  
  func loadChecklists() {
    let path = dataFilePath()
    if let data = try? Data(contentsOf: path) {
      let decoder = PropertyListDecoder()
      do {
        lists = try decoder.decode([Checklist].self, from: data)
        print("load file thanh cong----")
      } catch {
        print("Error decoding list array: \(error.localizedDescription)")
      }
    }
  }
}


