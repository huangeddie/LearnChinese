//
//  ViewController.swift
//  LearnChinese
//
//  Created by Eddie Huang on 5/13/19.
//  Copyright © 2019 Eddie Huang. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController {
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var pastEntriesButton: UIButton!
    
    var currEntry: Entry?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        update()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        update()
    }
    
    private func update() {
        let dc = DataController {}
        
        let entriesFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Entry")
        
        do {
            let entries = try dc.managedObjectContext.fetch(entriesFetch) as! [Entry]
            self.currEntry = entries.last
        } catch {
            fatalError("Failed to fetch entries: \(error)")
        }
        
        textLabel.text = currEntry?.text ?? "Add an entry"
        
        pastEntriesButton.isHidden = currEntry == nil
    }
}

