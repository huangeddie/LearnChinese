//
//  NewEntryViewController.swift
//  LearnChinese
//
//  Created by Eddie Huang on 5/14/19.
//  Copyright © 2019 Eddie Huang. All rights reserved.
//

import UIKit
import CoreData

class NewEntryViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var sourcePicker: UIPickerView!
    @IBOutlet weak var textField: UITextField!
    
    var sources: [Source] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let dc = DataController {}
        
        let sourcesFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Source")
        
        do {
            self.sources = try dc.managedObjectContext.fetch(sourcesFetch) as! [Source]
        } catch {
            fatalError("Failed to fetch sources: \(error)")
        }
        
        sourcePicker.dataSource = self
        sourcePicker.delegate = self
        
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        guard let text = textField.text else {
            return
        }
        let sourceIndex = sourcePicker.selectedRow(inComponent: 0)
        let source = self.sources.count >= sourceIndex ? nil : self.sources[sourceIndex]
        
        let dc = DataController {}
        
        let entry = NSEntityDescription.insertNewObject(forEntityName: "Entry", into: dc.managedObjectContext) as! Entry
        
        entry.text = text
        entry.created = Date()
        entry.source = source
        
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
    
    
    // MARK: - UIPickerDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.sources.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.sources[row].name
    }

}
