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
        
        let array: [[String: Any]] = [["idstr": "101", "text": "微博-101啊啊啊啊啊啊啊啊"],
                     ["idstr": "102", "text": "微博-102"],
                     ["idstr": "103", "text": "微博-103"],
                     ["idstr": "104", "text": "微博-104"],
                     ["idstr": "105", "text": "微博-105"],
                     ["idstr": "106", "text": "微博-106"],
                     ["idstr": "107", "text": "微博-107"],
                     ["idstr": "108", "text": "微博-108"],
                     ["idstr": "109", "text": "微博-109"],
                     ["idstr": "110", "text": "微博-110"],
                     ["idstr": "111", "text": "微博-111"],
                     ["idstr": "112", "text": "微博-112"],
                     ["idstr": "113", "text": "微博-113"],
                     ["idstr": "114", "text": "微博-114"],
                     ["idstr": "115", "text": "微博-115"],
                     ["idstr": "116", "text": "微博-116"],
                     ["idstr": "117", "text": "微博-117"],
                     ["idstr": "118", "text": "微博-118"],
                     ["idstr": "119", "text": "微博-119"],
                     ["idstr": "120", "text": "微博-120"]]
        SQLiteManager.share.updateStatus(userId: "1", array: array)
        print(SQLiteManager.share)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

