//
//  resultsPageView.swift
//  HanjaLex
//
//  Created by Kevin Fu on 11/19/19.
//  Copyright © 2019 Kevin Fu. All rights reserved.
//

// TO-DO LIST:
// make the navigation bar bigger? Or if not, make a section (UIView that locks in place) under the nav bar for showing the hangul/hanja bigger,
// and show the intermediary info (for hangul input, list all the related Hanjas. for hanja, show hanja definition on first line, then radicals).
// to do this, you'll have to delete this view controller and change it from TableViewController to UIViewController. make sure to keep the code! (done)

import UIKit
import SQLite

struct HanjaInfo {
    var hanja: String = ""
    var hangul: String = ""
    var english: String = ""
}

class resultsPageView: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {

    var database: Connection!
    
    var isKoreanInput: Bool!
    var searchRequest: String!
    var hanjaSelection: String!
    var resultsArray = [HanjaInfo]()
    var infoArray = [String]()
    
    @IBOutlet weak var resultsTable: UITableView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var searchedLabel: UILabel!
    @IBOutlet weak var infoCollection: UICollectionView!
    @IBOutlet weak var definitionLabel: UILabel!
    
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
        
        loadInfoBox()
        loadTable()
        self.resultsTable.reloadData()
        
        infoCollection.delegate = self
        infoCollection.dataSource = self
        
//        let layout = self.infoCollection.collectionViewLayout as! UICollectionViewFlowLayout
//        layout.minimumInteritemSpacing = 0
        
        resultsTable.delegate = self
        resultsTable.dataSource = self
    }
    
    func loadInfoBox() {
        self.searchedLabel.text = self.searchRequest
        
        do {
            let infos:Statement
            let dbDefinition:Statement
            if self.isKoreanInput {
                // show horizonally swipable field that shows possible hanjas
                
                //self.associatedLabel.text = "Associated Hanja:"
                
                self.definitionLabel.text = ""
                
                infos = try self.database.prepare("SELECT hanjas from korean_pronunciation WHERE hangul = '\(self.searchRequest ?? "인")'")

                var hanjaString: String = ""
                for row in infos {
                    hanjaString = row[0] as! String
                }
                for char in hanjaString {
                    if char != " " { self.infoArray.append(String(char))} }
                }
            
            else {
                // show definition (to the right of searchText)
                // & radicals below
                
                //self.associatedLabel.text = "Associated Hanja Radicals:"
                
                dbDefinition = try self.database.prepare("SELECT definition FROM hanja_definition WHERE hanjas = '\(self.searchRequest ?? "인")'")
                
                var definition: String = ""
                for row in dbDefinition {
                    definition = row[0] as! String
                }
                self.definitionLabel.text = definition
                
                infos = try self.database.prepare("SELECT radical FROM radicals WHERE hanjas LIKE '%\(self.searchRequest ?? "人")%'")
                
                for radical in infos {
                    //print(radical)
                    self.infoArray.append(radical[0] as! String)
                }
            }
            
        }
        catch { print(error) }
        
    }
    
    func loadTable() {
        // with given searchRequest, perform SQL query and put each row into table
        
        do {
            let infos:Statement
            if self.isKoreanInput { infos = try self.database.prepare("SELECT hanja, hangul, english from hanjas WHERE hangul LIKE '\(self.searchRequest ?? "인")%' ORDER BY hangul") }
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
    
    /////////////////
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.infoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let info = self.infoArray[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "infoCell", for: indexPath) as! infoCell
        cell.setString(info: info)
        
        return cell
    }
    
    /////////////////
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // how many rows should the table have?
        
        return self.resultsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // where is the table?
        
        let result = self.resultsArray[indexPath.row]
        let cell = self.resultsTable.dequeueReusableCell(withIdentifier: "cell") as! resultsCell
        cell.setResult(result: result)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
