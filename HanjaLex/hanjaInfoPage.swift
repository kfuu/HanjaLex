//
//  hanjaInfoPage.swift
//  HanjaLex
//
//  Created by Kevin Fu on 11/14/19.
//  Copyright © 2019 Kevin Fu. All rights reserved.
//

import UIKit
//import UPCarouselFlowLayout

class hanjaInfoPage: UIViewController {
    
    var hanjaClicked: String!
    @IBOutlet weak var currentHanja: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.currentHanja.text = hanjaClicked
        
        print("hi")
        
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
