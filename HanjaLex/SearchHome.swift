//
//  ViewController.swift
//  HanjaLex
//
//  Created by Kevin Fu on 11/12/19.
//  Copyright © 2019 Kevin Fu. All rights reserved.
//

// TO-DO LIST:
// (MAYBE) implement drop down menu of results (max 5 at a time?)
// 

import UIKit
import SQLite
import NaturalLanguage

class SearchHome: UIViewController, UISearchBarDelegate {
    
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
    
    //////////////////// USER DEFINED FUNCTIONS ////////////
    
    func detectedLanguage(for string: String) -> String? {
        let recognizer = NLLanguageRecognizer()
        recognizer.processString(string)
        guard let languageCode = recognizer.dominantLanguage?.rawValue else { return nil }
        let detectedLanguage = Locale.current.localizedString(forIdentifier: languageCode)
        return detectedLanguage
    }
    
    //////////////////// SEARCHBAR DELEGATE FUNCTIONS ////////////
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // everytime something gets typed into the search bar, this function is called.
        self.searchInput = hanjaSearchBar.text
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // called whenever the searchButton is clicked
        
        if isSearchBarEmpty()   {
            let emptyAlert = UIAlertController(title: "Please enter something in the search field to start searching!", message: nil, preferredStyle: .alert)
            emptyAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in print("OK") } ))
            self.present(emptyAlert, animated: true, completion: nil)
        }
            
        else {
            if self.searchInput.contains(" ") {
                let spacesAlert = UIAlertController(title: "You have spaces in your search query. Would you like to search with the spaces removed?", message: "If you choose NO, you probably will not get any relevant results.", preferredStyle: .alert)
                
                spacesAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                    self.searchInput.removeAll(where: {$0 == " "})
                    if self.searchInput == "" { self.searchInput = "人" }
                    
                    self.performSegue(withIdentifier: "resultsID", sender: self) }))
                
                spacesAlert.addAction(UIAlertAction(title: "No", style: .default, handler: { action in self.performSegue(withIdentifier: "resultsID", sender: self) }))
                
                self.present(spacesAlert, animated: true)
            }
            
            else { performSegue(withIdentifier: "resultsID", sender: self) }
            
        }

    }
    
    func isSearchBarEmpty() -> Bool {
        return self.hanjaSearchBar.text?.isEmpty ?? true
    }
    
    //////////////////// SEGUE PREPARATION ////////////
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "resultsID"{
            let destVC = segue.destination as! UINavigationController
            let results = destVC.topViewController as! resultsPageView
            
            results.searchRequest = self.searchInput
            results.isKoreanInput = detectedLanguage(for: self.searchInput) ?? "Korean" == "Korean"
        }
    }
    
    @IBAction func didUnwind(_ sender: UIStoryboardSegue) {
        guard let resultsVC = sender.source as? resultsPageView else {return}
        
    }

}

