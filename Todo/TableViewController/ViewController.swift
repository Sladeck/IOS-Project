//
//  ViewController.swift
//  TableViewController
//
//  Created by SUP'Internet 05 on 02/06/2017.
//  Copyright © 2017 SUP'Internet 05. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var myView: UIView!
    var text = "Default Text"
    var infos = "Default Infos"

    
    @IBOutlet weak var infosLabel: UILabel!
    //@IBOutlet weak var myButton: UIButton!
    @IBOutlet weak var myLabel: UILabel!

    
    //@IBAction func dimiss(_ sender: Any) {
    //    self.dismiss(animated: true, completion: nil)
    //}
    override func viewDidLoad() {
        //myLabel.text = self.text
        do {
            let attrStr = try NSAttributedString(
                data: text.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
                options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                documentAttributes: nil)
            myLabel.attributedText = attrStr
            
            let attrStr2 = try NSAttributedString(
                data: infos.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
                options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                documentAttributes: nil)
            infosLabel.attributedText = attrStr2
            
    
        } catch let error {
            print(error)
        }

        
        
    }
}

