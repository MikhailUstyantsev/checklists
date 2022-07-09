//
//  DataModel.swift
//  Checklists
//
//  Created by Михаил on 29.06.2022.
//

import Foundation

class DataModel {
    
    var lists = [Checklist]()
    
    init() {
//This makes sure that as soon as the DataModel object is created, it will attempt to load Checklists.plist
        loadChecklists()
        registerDefaults()
        handleFirstTime()
    }
    
    var indexOfSelectedChecklist: Int {
        get {
            return UserDefaults.standard.integer(forKey: "ChecklistIndex")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
        }
    }
    
    
    func handleFirstTime() {
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: "FirstTime")
        
        if firstTime {
            let checklist = Checklist(name: "List")
            lists.append(checklist)
            
            indexOfSelectedChecklist = 0
            userDefaults.set(false, forKey: "FirstTime")
        }
    }
    
    
    
    
    //    MARK: - Data Saving
        
        //    Get the save file path
        /*
         The documentsDirectory() returns the full path to the Documents folder.
         The dataFilePath() method uses documentsDirectory() to construct the full path to the file that will store the checklist items. This file is named Checklists.plist and it lives inside the Documents folder.
         */

        func documentDirectory() -> URL {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            return paths[0]
        }

        func dataFilePath() -> URL {
            return documentDirectory().appendingPathComponent("Checklists.plist")
        }
    //    //  This method takes the contents of the items array, converts it to a block of binary data, and then writes this data to a file
        func saveChecklists() {
            let encoder = PropertyListEncoder()
            do {
                let data = try encoder.encode(lists)
                try data.write(to: dataFilePath(),
                               options: Data.WritingOptions.atomic)
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
                    sortChecklists()
                } catch {
                    print("Error decoding list array: \(error.localizedDescription)")
                }
            }
        }
    
   
    
    func registerDefaults() {
        let dictionary = ["ChecklistIndex": -1,
                          "FirstTime": true] as [String: Any]
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    
    func sortChecklists() {
//        The localizedStandardCompare(_:) method compares the two name strings while ignoring lowercase vs. uppercase (so “a” and “A” are considered equal) and taking into consideration the rules of the current locale.A locale is an object that knows about country and language-specific rules. Sorting in German  may be different than sorting in English, for example.
        lists.sort { list1, list2 in
            return list1.name.localizedStandardCompare(list2.name) == .orderedAscending
        }
    }
    
    
    class func nextChecklistItemID() -> Int {
        let userDefaults = UserDefaults.standard
        let itemID = userDefaults.integer(forKey: "ChecklistItemID")
        userDefaults.set(itemID + 1, forKey: "ChecklistItemID")
        return itemID
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}
