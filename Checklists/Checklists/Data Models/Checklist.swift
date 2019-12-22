//
//  Checklist.swift
//  Checklists
//
//  Created by NGUYENLONGTIEN on 12/10/19.
//  Copyright © 2019 NGUYENLONGTIEN. All rights reserved.
//

import Foundation
class Checklist: NSObject, Codable{
    var name = ""
    var items: [checkListItem] = [checkListItem]()
    var iconName = "No Icon"
    init(name:String, iconName:String = "No Icon"){
        self.name = name
        self.iconName = iconName
    }
    func countUncheckedItem() -> Int{
        var count = 0
        for item in items where !item.checked{
            count += 1 }
        return count
        }
}
