//
//  ViewController.swift
//  LearnChinese
//
//  Created by Eddie Huang on 5/13/19.
//  Copyright © 2019 Eddie Huang. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pinyinSwitch: UISwitch!
    
    var currEntry: Entry?
    var phrases: [String] = []
    var pinyins: [String]? = []
    var translations: [String]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        update()
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        update()
    }
    @IBAction func pinyinSwitched(_ sender: Any) {
        tableView.reloadData()
    }
    
    private func update() {
        
        let entriesFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Entry")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        do {
            let entries = try appDelegate.persistentContainer.viewContext.fetch(entriesFetch) as! [Entry]
            self.currEntry = entries.last
        } catch {
            fatalError("Failed to fetch entries: \(error)")
        }
        
        if let entry = currEntry {
            phrases = entry.text?.components(separatedBy: "|") ?? []
            pinyins = entry.pinyin?.components(separatedBy: "|") ?? nil
            translations = entry.translation?.components(separatedBy: "|") ?? nil
        } else {
            phrases = []
            pinyins = []
            translations = []
        }
        tableView.reloadData()
    }
}

extension MainViewController {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return phrases.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "phrase", for: indexPath) as! PhraseTableViewCell
        let phrase = phrases[indexPath.row]
        let pinyin = pinyins?[indexPath.row]
        let translation = translations?[indexPath.row]
        
        cell.phrase.text = phrase
        
        if pinyinSwitch.isOn {
            cell.pinyin.text = pinyin
            cell.translation.text = translation
        } else {
            cell.pinyin.text = nil
            cell.translation.text = nil
        }
        
        return cell
    }
}
