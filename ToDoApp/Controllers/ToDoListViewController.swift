//
//  ViewController.swift
//  ToDoApp
//
//  Created by Aldo Velasquez on 9/10/18.
//  Copyright © 2018 Aldo Velasquez. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController{

    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var addItemTextField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        let action = UIAlertAction(title: "Add Item", style: UIAlertActionStyle.default, handler: { (alert) in
            
            let newItem = Item()
            newItem.title = addItemTextField.text!
            
            self.itemArray.append(newItem)
            
            self.saveItems()
        })
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            addItemTextField = alertTextField
            print(alertTextField.text!)
        }
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }
        catch{
            print("Error in encoding array: \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
              itemArray = try decoder.decode([Item].self, from: data)
            }catch{
                print("Error decoding: \(error )")
            }
        }
    }
}

