//
//  ViewController.swift
//  TableViewController
//
//  Created by SUP'Internet 05 on 02/06/2017.
//  Copyright © 2017 SUP'Internet 05. All rights reserved.
//

import UIKit
import Alamofire
import SWXMLHash
import AlamofireObjectMapper
import ObjectMapper

class TableViewController: UITableViewController {
    
    var todoList : [todo]?
    var author = "Default"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 60.0
        self.view.backgroundColor = UIColor.gray
        
        let alert = UIAlertController(title: "Who are you ?", message: "Enter your username", preferredStyle: .alert)
        alert.addTextField(configurationHandler: { (tf: UITextField!) -> Void in
            tf.placeholder = "Username"
        })

        let connect = UIAlertAction(title: "Connect", style: .default) { (action) in
            if let tf = alert.textFields?[0] {
                self.author = tf.text!
                self.getThisJsonUrl()
            }
        }
        
        alert.addAction(connect)
        
        self.present(alert, animated: true, completion: nil)
        
        let barButton = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(buttonHasBeenPressed))
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    func buttonHasBeenPressed() {
        self.tableView.setEditing(!self.tableView.isEditing, animated: true)
    }
    
    @IBAction func pressed(_ sender: Any) {
        let alert = UIAlertController(title: "New todo", message: "Create a new todo", preferredStyle: .alert)
        
        let actionCancel = UIAlertAction(title: "Non", style: .destructive, handler: nil)
        let addRowAction = UIAlertAction(title: "Add", style: .default) { (action) in
            
    

            var title = "Default"
            
            if let tf = alert.textFields?[0] {
                title = tf.text!
            }
            
            let todoElement = todo(title: title, content: "Default content", author: "somebody")
            self.todoList?.append(todoElement!)
            
            let indexPath = IndexPath(row: (self.todoList?.count)! - 1, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .fade)
        }
        
        alert.addTextField(configurationHandler: { (tf: UITextField!) -> Void in
            tf.placeholder = "Title"
        })
        alert.addAction(actionCancel)
        alert.addAction(addRowAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func getThisJsonUrl() -> Void {
        Alamofire.request("http://localhost:8888/IOS-Project/API/api.php?action=get_user&pseudo="+"'"+self.author+"'").responseObject { (response: DataResponse<todo>) in
            let todoList = response.result.value
            print(response.result)
                                                                                                                                       
             if self.todoList == nil {
                self.todoList = []
            }
                                                                                                                                       
            if let todoListObject = todoList {
                self.todoList?.append(todoListObject)
            }
            
            self.tableView.reloadData()
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 0
        if let nbRows = self.todoList {
            rows = nbRows.count
        }
        return rows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "macell1", for: indexPath)
        if let mycell = cell as? MyTableViewCell {
            let myList = self.todoList
            let obj = myList?[indexPath.row]
            if let title = obj?.title {
                mycell.setLabel(value: title)
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.todoList?.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let tmp = self.todoList?[sourceIndexPath.row]
        self.todoList?.remove(at: sourceIndexPath.row)
        self.todoList?.insert(tmp!, at: destinationIndexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let ctr = segue.destination as? ViewController, let cell = sender as? MyTableViewCell, let indexPath = self.tableView.indexPath(for: cell){
            
            let myList = self.todoList
            let obj = myList?[indexPath.row]
            if let content = obj?.content, let author = obj?.author{
                ctr.text = content
                ctr.infos = author
    
            }
        }
    }
}

class todo: Mappable {
    var id: Int?
    var content: String?
    var author: String?
    var title: String?

    
    required init?(map: Map){
        
    }
    
    required init?(title: String, content: String, author: String) {
        self.title = title
        self.content = content
        self.author = author
    }
    
    func mapping(map: Map) {
        title <- map["title"]
        content <- map["content"]
        id <- map["id"]
        author <- map["author"]
    }
}
