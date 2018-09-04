//
//  SQLiteManager.swift
//  SwiftStudySQLite
//
//  Created by tangyunchuan on 2018/9/4.
//  Copyright © 2018年 tangyunchuan. All rights reserved.
//

import Foundation
import FMDB

/// SQLite管理器
/**
 1.数据库本质上是保存在沙盒中的一个文件，首先需要创建并且打开数据库
 2.FMDB - 队列
 3.创建数据库
 4.增删改查
 */


class SQLiteManager {
    /// 单例，全局数据库访问点
    static let share = SQLiteManager()
    
    let queue: FMDatabaseQueue
    
    /// 构造函数
    private init() {
        let dbName = "status.db"
        /// 数据库全路径 - path
        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        path = (path as NSString).appendingPathComponent(dbName)
        print("数据库的路径" + path)
        //创建数据库队列，同时‘创建或打开’数据库
        queue = FMDatabaseQueue(path: path)
    }
}
