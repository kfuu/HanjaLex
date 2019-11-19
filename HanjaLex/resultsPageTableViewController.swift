//
//  resultsPageTableViewController.swift
//  HanjaLex
//
//  Created by Kevin Fu on 11/13/19.
//  Copyright © 2019 Kevin Fu. All rights reserved.
//

// TO-DO LIST:
// make the navigation bar bigger? Or if not, make a section (UIView that locks in place) under the nav bar for showing the hangul/hanja bigger,
// and show the intermediary info (for hangul input, list all the related Hanjas. for hanja, show hanja definition on first line, then radicals).
// to do this, you'll have to delete this view controller and change it from TableViewController to UIViewController. make sure to keep the code!

import UIKit
import SQLite

struct HanjaInfo {
    var hanja: String = ""
    var hangul: String = ""
    var english: String = ""
}

class resultsPageTableViewController: UITableViewController{
    
    var database: Connection!
    
    var koreanInput: Bool!
    var searchRequest: String!
    var hanjaSelection: String!
    var resultsArray = [HanjaInfo]()
    
    @IBOutlet var resultsTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Searching for: " + searchRequest
        
        do {
//            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
//            //print(documentDirectory)
//            let fileUrl = documentDirectory.appendingPathComponent("hanjadic").appendingPathExtension("sqlite")
//            let database = try Connection(fileUrl.path)
            let database = try Connection("/Users/kfu101/Documents/HanjaLex/HanjaLex/hanjadic.sqlite")
            self.database = database
        }
        catch { print(error) }
        
        loadTable()
        
        self.resultsTable.reloadData()
    }
    
    func loadTable() {
        // with given searchRequest, perform SQL query and put each row into table
        
        do {
            let infos:Statement
            if self.koreanInput { infos = try self.database.prepare("SELECT hanja, hangul, english from hanjas WHERE hangul LIKE '\(self.searchRequest ?? "인")%' ORDER BY hangul") }
            else                { infos = try self.database.prepare("SELECT hanja, hangul, english from hanjas WHERE hanja LIKE '%\(self.searchRequest ?? "人")%' ORDER BY hangul") }
            
            for row in infos {
                var newEntry = HanjaInfo()
                
                newEntry.hanja = row[0] as! String
                newEntry.hangul = row[1] as! String
                newEntry.english = row[2] as! String
                
                self.resultsArray.append(newEntry)
            }
        } catch { print(error) }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // how many rows should the table have?
        return self.resultsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // where is the table?
        
        let result = self.resultsArray[indexPath.row]
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! resultsCell
        cell.setResult(result: result)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.hanjaSelection = self.resultsArray[indexPath.row].hanja as String?
        performSegue(withIdentifier: "toHanjaInfo", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toHanjaInfo" {
            //let destVC = segue.destination as! UINavigationController
            let hanjaPage = segue.destination as! hanjaInfoPage
            hanjaPage.hanjaClicked = self.hanjaSelection
        }
        
    }
    
}
