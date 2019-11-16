//
//  ViewController.swift
//  HanjaLex
//
//  Created by Kevin Fu on 11/12/19.
//  Copyright © 2019 Kevin Fu. All rights reserved.
//

import UIKit
import SQLite

class ViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var hanjaSearchBar: UISearchBar!
    var searchInput: String!
    
    var database: Connection!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //self.navigationItem.backBarButtonItem!.title = "Back"
        self.navigationItem.title = "Search"
        
        self.hanjaSearchBar.searchBarStyle = .minimal// makes it look pretty
        self.hanjaSearchBar.delegate = self // makes it so that the delegate property of the search bar can use the delegate methods. in plain english, if this was not here, the textDidChange function would not be called.
        
        // connecting to the database
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("hanjadic").appendingPathExtension("sqlite")
            let database = try Connection(fileUrl.path)
            self.database = database
        }
        catch { print(error) }
        
    } // end viewDidLoad()
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // everytime something gets typed into the search bar, this function is called.
        self.searchInput = hanjaSearchBar.text
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        performSegue(withIdentifier: "resultsID", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "resultsID"{
            let destVC = segue.destination as! UINavigationController
            let results = destVC.topViewController as! resultsPageTableViewController
            results.searchRequest = self.searchInput
        }
    }

}

