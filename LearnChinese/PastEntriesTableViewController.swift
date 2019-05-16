//
//  PastEntriesTableViewController.swift
//  LearnChinese
//
//  Created by Eddie Huang on 5/16/19.
//  Copyright © 2019 Eddie Huang. All rights reserved.
//

import UIKit
import CoreData

class PastEntriesTableViewController: UITableViewController {

    var entries: [Entry] = []
    let dc = DataController{}
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        let entriesFetch: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        do {
            self.entries = try dc.managedObjectContext.fetch(entriesFetch)
        } catch {
            fatalError("Failed to fetch entries: \(error)")
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let entry = entries[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "entry", for: indexPath)
        // Configure the cell...
        
        let truncate = { (string: String, length: Int, trailing: String ) -> String in
            if string.count > length {
                return String(string.prefix(length)) + trailing
            } else {
                return string
            }
        }
        
        if let entryText = entry.text {
            cell.textLabel?.text = truncate(entryText, 50, "...")
        }
        
        let df = DateFormatter()
        df.dateStyle = .medium
        
        cell.detailTextLabel?.text = df.string(from: entry.created!)
        
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
            
            let entry = entries[indexPath.row]
            dc.managedObjectContext.delete(entry)
            do {
                try dc.managedObjectContext.save()
            } catch {
                fatalError("Failed to delete entry")
            }
            
            entries.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
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
