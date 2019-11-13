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
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var database: Connection!
    let hanjas = Expression<String>("hanjas")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("hanjadict").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
        }
        catch {
            print(error)
        }
        
    } // end viewDidLoad()
    
    
    @IBAction func testDatabase() {
        print("TESTING DATABASE")
        
        do {
            let radicals = try self.database.prepare(Table("radicals"))
            for radical in radicals {
                print("radical: \(radical[self.hanjas])")
            }
            
        } catch {
            print(error)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            
            performSegue(withIdentifier: "hanjaTable", sender: self)
        }
    }
    

}

