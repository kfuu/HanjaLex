//
//  hanjaInfoPage.swift
//  HanjaLex
//
//  Created by Kevin Fu on 11/14/19.
//  Copyright © 2019 Kevin Fu. All rights reserved.
//

import UIKit
import SQLite
import WebKit
//import UPCarouselFlowLayout

class hanjaInfoPage: UIViewController {
    
    var hanjaClicked: String!
    @IBOutlet weak var currentHanja: UILabel!
    @IBOutlet weak var radicalLabel: UILabel!
    var radicalString:String = "radicals: "
    
    var database: Connection!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentHanja.text = self.hanjaClicked
        
//        let encodedHanja = hanjaClicked.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) //as! String // converts a Chinese character / hangul character to something that can be used in URL
//        // check for case of multiple characters in hanjaClicked
//        let url = "https://en.wiktionary.org/wiki/\(encodedHanja ?? "%E4%BA%BA")" // default value is 人 for now
//        guard let myURL = URL(string: url) else {
//            print("Error: \(url) doesn't seem to be a valid URL")
//            return
//        }
//        do {
//            let myHTMLString = try String(contentsOf: myURL, encoding: .ascii)
//            print("HTML : \(myHTMLString)")
//        } catch let error {
//            print("Error : \(error)")
//        }
        
        do {
//            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
//            //print(documentDirectory)
//            let fileUrl = documentDirectory.appendingPathComponent("hanjadic").appendingPathExtension("sqlite")
//            let database = try Connection(fileUrl.path)
            let database = try Connection("/Users/kfu101/Documents/HanjaLex/HanjaLex/hanjadic.sqlite")
            self.database = database
        }
        catch { print(error) }
        
        loadInfo()
    
        // "https://en.wiktionary.org/wiki/\(hanjaClicked)"
        // using urlsession and getting json from webpage
//        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else { return }
//        print("test")
//        let session = URLSession.shared
//        session.dataTask(with: url) { (data, response, error) in
//            if let response = response {
//                print(response)
//            }
//
//            if let data = data {
//                print(data)
//                do {
//                    let json = try JSONSerialization.jsonObject(with: data, options: [])
//                    print(json)
//                } catch { print(error) }
//            }
//        }.resume()
//
//        // Do any additional setup after loading the view.
//        print("hello")
        
    } // end viewDidLoad()
    
    let colors = [UIColor.blue, UIColor.green, UIColor.orange, UIColor.lightGray, UIColor.red]
    func loadInfo() {
        do {
            var buttonX: CGFloat = 150
            var buttonY: CGFloat = 250
            var i = 0
            
            for char in hanjaClicked {
                let infos = try self.database.prepare("SELECT radical from radicals WHERE hanjas LIKE '%\(char ?? "人")%'")
                
                for row in infos {
                    //self.radicalString += (row[0] as! String + " ")
                    let hanjaButton = UIButton(frame: CGRect(x: buttonX, y: buttonY, width: 30, height: 30))
                    if buttonX >= 350 {
                        buttonX = 50
                        buttonY += 50
                    }
                    else { buttonX = buttonX + 50 }
                    
                    hanjaButton.backgroundColor = self.colors[i]
                    hanjaButton.layer.cornerRadius = 10
                    hanjaButton.setTitle(row[0] as? String, for: [])
                    hanjaButton.addTarget(self, action: #selector(hanjaPressed), for: .touchDown)
                    self.view.addSubview(hanjaButton)
                    
                } // end infos for loop
                i += 1
                
            } // end hanjaClicked for loop
            
            //self.radicalLabel.text = self.radicalString
        } catch { print(error) }
        
    } // end loadInfo
    
    @objc func hanjaPressed(sender: UIButton!){
        // perform segue
        if sender.titleLabel?.text != nil {
            print(sender.titleLabel?.text as! String)
        }
        else { print("error") }
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
