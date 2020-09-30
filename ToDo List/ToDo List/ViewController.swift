//
//  ViewController.swift
//  ToDo List
//
//  Created by Quentin Ikuta on 9/30/20.
//

import Cocoa

class ViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {

    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var importantCheckbox: NSButton!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var deleteButton: NSButton!
    
    var toDoItems : [ToDoItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    func getToDoItems(){
        //get todo items from core data
        if let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            
            do{
            toDoItems = try context.fetch(ToDoItem.fetchRequest())
                print(toDoItems.count)
            }catch{}
        }
        
        //update the table
        tableView.reloadData()
        
        
    }
    
    @IBAction func addClicked(_ sender: Any) {
        if textField.stringValue != ""{
            
            if let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                
                let toDoItem = ToDoItem(context: context)
                
                toDoItem.name = textField.stringValue
                
                if importantCheckbox.state.rawValue == 0{ // added rawValue to fix
                    //Not important
                    toDoItem.important = false
                } else {
                    //Important
                    toDoItem.important = true
                }
                
                (NSApplication.shared.delegate as? AppDelegate)?.saveAction(nil) // saving values
                
                textField.stringValue = "" // resetting textfield
                importantCheckbox.state = NSControl.StateValue(rawValue: 0) //resetting checkbox
                
                getToDoItems()
            }
        }
    }

    
    @IBAction func deleteClicked(_ sender: Any) {
        
        let toDoItem = toDoItems[tableView.selectedRow]
        if let context = (NSApplication.shared.delegate as?
            AppDelegate)?.persistentContainer.viewContext {
            
            context.delete(toDoItem)
            
            (NSApplication.shared.delegate as? AppDelegate)?.saveAction(nil) // saving
            
            getToDoItems()
            
            deleteButton.isTransparent = true
        }

    }
    
    // MARK: - TableView Stuff


    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return toDoItems.count
    }
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let toDoItem = toDoItems[row]
        
        if tableColumn?.identifier.rawValue == "importantColumn" {
            //IMPORTANT
            if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "importantCell"), owner: self) as? NSTableCellView{
                
                if toDoItem.important {
                    cell.textField?.stringValue = "❗️"
                } else{
                    cell.textField?.stringValue = ""
                }
                
                
                return cell
            }
        } else {
            //TODO Name
            if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "todoItems"), owner: self) as? NSTableCellView{
                cell.textField?.stringValue = toDoItem.name!
                
                return cell
            }
        }
        return nil
    }
    
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        deleteButton.isTransparent = false
        
    }
    
    
    
    
    
    
    
    
    
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

