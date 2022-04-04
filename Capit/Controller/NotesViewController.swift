//
//  NotesViewController.swift
//  Capit
//
//  Created by Abdullah on 29/02/2020.
//  Copyright © 2020 Abdullah. All rights reserved.
//

import UIKit
import RealmSwift

class NotesViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var notesArray: Results<Note>?
    
    var selectedClass: Class? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - AddingToTableView
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Create a new Note", message: nil, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Create Note", style: .default) { (action) in
            
            
            let newNote = Note()
            newNote.title = textField.text!
            
            self.save(note: newNote)
            
            
            
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new Class"
            textField = alertTextField
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
            
            alert.dismiss(animated: true, completion: nil)
            
        }))
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - TableViewManipulation
    
    func loadItems() {
        self.title = selectedClass?.title
        
        notesArray = selectedClass?.notes.sorted(byKeyPath: "dateCreated")
        
        tableView.reloadData()
    }
    
    func save(note: Note) {
        do {
            try realm.write {
                if let currentClass = selectedClass {
                    currentClass.notes.append(note)
                }
                realm.add(note)
            }
        } catch {
            print("Error saving new note: \(error)")
        }
    }
    
    //MARK: - deleteDataFromTable
    override func updateModel(at indexPath: IndexPath) {
        //        handle action by updating model with deletion
        do {
            try self.realm.write {
                if let notes = self.notesArray {
                    self.realm.delete(notes[indexPath.row])
                    //                    self.animatedTableViewReload()
                }
                
            }
        } catch {
            print("Error deleting data \(error)")
        }
    }
    
    //MARK: - tableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        let noteToDisplay = notesArray?[indexPath.row]
        cell.textLabel?.font = UIFont(name: "RobotoMono-Medium", size: 30)
        cell.textLabel?.text = noteToDisplay?.title ?? "No class added yet"
        
        return cell
    }
    
    //MARK: - tableViewManipulation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToNote", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! NoteViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedNote = notesArray?[indexPath.row]
        }
        
    }
    
}
