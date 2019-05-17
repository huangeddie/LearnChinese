//
//  SourcesTableViewController.swift
//  LearnChinese
//
//  Created by Eddie Huang on 5/16/19.
//  Copyright © 2019 Eddie Huang. All rights reserved.
//

import UIKit
import CoreData

class SourcesTableViewController: UITableViewController {
    
    var sources: [Source] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        update()
        
    }
    
    func update() -> Void {
        let fetchRequest: NSFetchRequest<Source> = Source.fetchRequest()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        do {
            self.sources = try appDelegate.persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            fatalError("Failed to fetch entries: \(error)")
        }
        
        tableView.reloadData()
    }
    
    
    @IBAction func addSource(_ sender: Any) {
        
    
        let alert = UIAlertController(title: "New Source", message: nil, preferredStyle: .alert)
        alert.addTextField { (nameTextField) in
            nameTextField.placeholder = "Name"
        }
        
        alert.addTextField { (URLTextField) in
            URLTextField.placeholder = "URL"
        }
        
        let createSource = { (_: UIAlertAction) in
            let name = alert.textFields![0].text
            
            let url = URL(string: alert.textFields![1].text!)
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            let source = NSEntityDescription.insertNewObject(forEntityName: "Source", into: appDelegate.persistentContainer.viewContext) as! Source
            
            source.name = name
            source.url = url
            
            appDelegate.saveContext()
            self.update()
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Save", comment: "Default action"), style: .default, handler: createSource))
        
        self.present(alert, animated: true, completion: nil)
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
    
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sources.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let source = sources[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "source", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = source.name
        cell.detailTextLabel?.text = source.url?.absoluteString
        
        return cell
    }



    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }



    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let source = sources[indexPath.row]
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.persistentContainer.viewContext.delete(source)
            appDelegate.saveContext()
            
            sources.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let source = sources[indexPath.row]
        if let url = source.url {
            UIApplication.shared.open(url)
        }
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
