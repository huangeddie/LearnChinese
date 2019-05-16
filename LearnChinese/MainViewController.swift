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
    @IBOutlet weak var pastEntriesButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pinyinSwitch: UISwitch!
    
    var currEntry: Entry?
    var chunks: [String] = []
    var pinyins: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        update()
        tableView.dataSource = self
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
        
        if let entry = currEntry {
            chunks = entry.text?.components(separatedBy: "\n") ?? []
            pinyins = chunks
        } else {
            chunks = ["建最選状裏問右質昨名念済臭能季外最情。"]
            pinyins = ["Jiàn zuì xuǎn zhuàng lǐ wèn yòu zhì zuó míng niàn jì chòu néng jì wài zuì qíng."]
        }
    }
}

extension MainViewController {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return chunks.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chunk", for: indexPath) as! ChunkTableViewCell
        let chunk = chunks[indexPath.row]
        let pinyin = pinyins[indexPath.row]
        cell.chunk.text = chunk
        cell.pinyin.text = pinyin
        
        return cell
    }
}
