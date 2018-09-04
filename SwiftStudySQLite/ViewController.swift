//
//  ViewController.swift
//  SwiftStudySQLite
//
//  Created by tangyunchuan on 2018/9/4.
//  Copyright © 2018年 tangyunchuan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print(SQLiteManager.share)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

