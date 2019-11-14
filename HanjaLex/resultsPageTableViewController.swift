//
//  resultsPageTableViewController.swift
//  HanjaLex
//
//  Created by Kevin Fu on 11/13/19.
//  Copyright © 2019 Kevin Fu. All rights reserved.
//

import UIKit
import SQLite

class resultsPageTableViewController: UITableViewController{
    
    var database: Connection!
    
    var searchRequest: String!
    var resultsArray = [(String, String, String)]()

    @IBOutlet var resultsTable: UITableView!
    @IBOutlet weak var resultTitle: UINavigationItem!
    
    class HeadlineTableViewCell: UITableViewCell {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        print("searchRequest: " + searchRequest)
        self.resultTitle.title = "Searching for: " + searchRequest
        // FIX THIS
        // also add back button
        // implement multiple elements in cell
        // implement segue to hanja page
        // etc
        
        //self.sampleItems.append(searchRequest)
        //print(self.sampleItems)
        
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("hanjadic").appendingPathExtension("sqlite")
            let database = try Connection(fileUrl.path)
            self.database = database
        }
        catch { print(error) }
        
        loadTable()
        self.resultsTable.reloadData()


        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
    }
    
    func loadTable() {
        // with given searchRequest, perform SQL query and put each row into table
        
        do {
            let infos = try self.database.prepare("SELECT hanja, hangul, english from hanjas WHERE hangul LIKE '\(self.searchRequest ?? "인")%' ORDER BY hangul")
            
            for row in infos {
                self.resultsArray.append((row[0]! as! String, row[1]! as! String, row[2]! as! String))
                //print("\(row[0])     \(row[1])      \(row[2])")
                
            }
            
        } catch {
            print(error)
        }
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // what's in each row?
        cell.textLabel?.text = resultsArray[indexPath.row].0 + "    " + resultsArray[indexPath.row].1 + "    " + resultsArray[indexPath.row].2

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
