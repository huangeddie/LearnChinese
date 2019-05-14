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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let dc = DataController(completionClosure: self.foo)
        
        let entry = NSEntityDescription.insertNewObject(forEntityName: "Entry", into: dc.managedObjectContext) as! Entry
        entry.text = "Hello World"
        entry.name = "Foo"
        entry.created = Date.distantPast
        
        do {
            try dc.managedObjectContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
        
        let entriesFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Entry")
        
        do {
            let fetchedEntries = try dc.managedObjectContext.fetch(entriesFetch) as! [Entry]
            print(fetchedEntries)
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
        
    }
    
    func foo() -> Void {
        print("Hello")
    }


}

