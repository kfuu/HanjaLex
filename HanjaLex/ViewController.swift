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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("hanjadic").appendingPathExtension("sqlite")
            let database = try Connection(fileUrl.path)
            self.database = database
        }
        catch {
            print(error)
        }
        
    } // end viewDidLoad()
    
    
    @IBAction func testDatabase(_ sender: UIButton) {
        print("TESTING DATABASE")
        
        //print(database)

        do {
            let radicals = try self.database.prepare(Table("radicals"))
            for radical in radicals {
                print("\(radical[Expression<String>("radical")])      \(radical[Expression<String>("hanjas")])")
                print()
            }
            
            let hanjas = try self.database.prepare("SELECT hanjas, definition FROM hanja_definition WHERE hanjas = '全'")
            for row in hanjas {
                print("\(row[0] ?? "None")         \(row[1] ?? "None" )")
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

