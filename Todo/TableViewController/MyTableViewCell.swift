//
//  TebleViewCell.swift
//  TableViewController
//
//  Created by SUP'Internet 05 on 02/06/2017.
//  Copyright © 2017 SUP'Internet 05. All rights reserved.
//

import Foundation
import UIKit


class MyTableViewCell : UITableViewCell {
    
    @IBOutlet weak var myLabel: UILabel!
    func setLabel(value : String) -> Void{
        myLabel.text = value
    }
}
