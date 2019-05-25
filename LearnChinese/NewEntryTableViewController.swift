//
//  NewEntryTableViewController.swift
//  LearnChinese
//
//  Created by Eddie Huang on 5/16/19.
//  Copyright © 2019 Eddie Huang. All rights reserved.
//

import UIKit
import CoreData

class NewEntryTableViewController: UITableViewController, UITextFieldDelegate {

    var phrases: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func save(_ sender: Any) {
        let chinese = phrases.joined(separator: "|")
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let entry = NSEntityDescription.insertNewObject(forEntityName: "Entry", into: appDelegate.persistentContainer.viewContext) as! Entry
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let translateRaw = "https://translation.googleapis.com/v3beta1/projects/mysite-202703/locations/global:translateText?target_language_code=en&contents=\(chinese)&source_language_code=zh-CN".addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!
        let translateURL = URL(string: translateRaw)!
        var translateRequest = URLRequest(url: translateURL)
        translateRequest.httpMethod = "POST"
        translateRequest.setValue("Bearer AIzaSyDjGLzklbG2Vi4bWh6Se2LFTWZ_vuXD-_s",
                         forHTTPHeaderField: "Authorization")
        translateRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let translateTask =  URLSession.shared.dataTask(with: translateRequest) { (data, response, error) in
            if let data = data {
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                let translations = json?["translations"] as? [[String: Any]]
                entry.translation = translations?[0]["translatedText"] as? String
            } else {
                print("Translate error: \(error)")
            }
            semaphore.signal()
        }
        
        translateTask.resume()
        
        // Wait for both translation
        semaphore.wait()
        
        entry.text = chinese
        entry.pinyin = chinese.applyingTransform(.toLatin, reverse: false)
        entry.created = Date()
        
        appDelegate.saveContext()
        
        dismiss(animated: true, completion: nil)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return phrases.count + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "phrase", for: indexPath) as! NewPhraseTableViewCell

        // Configure the cell...
        cell.phraseField.delegate = self
        
        if indexPath.row < phrases.count {
            cell.phraseField.text = phrases[indexPath.row]
            cell.phraseField.isUserInteractionEnabled = false
        } else {
            cell.phraseField.text = nil
            cell.phraseField.isUserInteractionEnabled = true
        }

        return cell
    }


    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        if indexPath.row == phrases.count {
            return false
        } else {
            return true
        }
    }
 

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            phrases.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let phrase = phrases.remove(at: fromIndexPath.row)
        phrases.insert(phrase, at: to.row)
    }

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


extension NewEntryTableViewController {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textField.isUserInteractionEnabled = false
        phrases.append(textField.text!)
        tableView.reloadData()
        return true
    }
}
