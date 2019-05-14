//
//  ViewController.swift
//  LearnChinese
//
//  Created by Eddie Huang on 5/13/19.
//  Copyright © 2019 Eddie Huang. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let dc = DataController(completionClosure: self.foo)
        
    }
    
    func foo() -> Void {
        print("Hello")
    }


}

