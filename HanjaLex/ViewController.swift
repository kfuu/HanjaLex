//
//  ViewController.swift
//  HanjaLex
//
//  Created by Kevin Fu on 11/12/19.
//  Copyright © 2019 Kevin Fu. All rights reserved.
//

import UIKit
import SQLite
import NaturalLanguage

class ViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var hanjaSearchBar: UISearchBar!
    var searchInput: String!
    
    var database: Connection!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hanjaSearchBar.searchBarStyle = .minimal// makes it look pretty
        self.hanjaSearchBar.delegate = self // makes it so that the delegate property of the search bar can use the delegate methods. in plain english, if this was not here, the textDidChange function would not be called.
        
        // connecting to the database
        do {
            //let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            //let fileUrl = documentDirectory.appendingPathComponent("hanjadic").appendingPathExtension("sqlite")
            //let database = try Connection(fileUrl.path)
            let database = try Connection("/Users/kfu101/Documents/HanjaLex/HanjaLex/hanjadic.sqlite")
            self.database = database
        }
        catch { print(error) }
        
    } // end viewDidLoad()
    
    func detectedLanguage(for string: String) -> String? {
        let recognizer = NLLanguageRecognizer()
        recognizer.processString(string)
        guard let languageCode = recognizer.dominantLanguage?.rawValue else { return nil }
        let detectedLanguage = Locale.current.localizedString(forIdentifier: languageCode)
        return detectedLanguage
    }
    
    
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
            
            if detectedLanguage(for: self.searchInput)! == "Korean"     { results.koreanInput = true }
            else if detectedLanguage(for: self.searchInput)! == "Chinese (Traditional)" || detectedLanguage(for: self.searchInput)! == "Chinese (Simplified)"                                           { results.koreanInput = false }
            else                                                        { results.koreanInput = false } // non korean & non chinese
        }
    }
    
    @IBAction func didUnwind(_ sender: UIStoryboardSegue) {
        guard let resultsVC = sender.source as? resultsPageTableViewController else {return}
        
    }

}

