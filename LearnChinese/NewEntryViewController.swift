//
//  NewEntryViewController.swift
//  LearnChinese
//
//  Created by Eddie Huang on 5/14/19.
//  Copyright © 2019 Eddie Huang. All rights reserved.
//

import UIKit
import CoreData

class NewEntryViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        textView.becomeFirstResponder()
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        guard let text = textView.text else {
            return
        }
        
        let dc = DataController {}
        
        let entry = NSEntityDescription.insertNewObject(forEntityName: "Entry", into: dc.managedObjectContext) as! Entry
        
        entry.text = text
        entry.created = Date()
        
        do {
            try dc.managedObjectContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
        
        dismiss(animated: true, completion: nil)
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
