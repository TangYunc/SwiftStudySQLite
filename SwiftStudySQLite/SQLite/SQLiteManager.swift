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
 
 提示：数据库开发，程序代码几乎都是一直的，区别在SQL
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
        //打开数据库
        creatTable()
    }
}

// MARK: - 微博数据操作
extension SQLiteManager {
    
    /**
        思考：从网络加载结束后，返回的是微博的‘字典数组’，每一个字典对应一个完整的微博记录，         - 完整的微博记录中，包含微博的代号
            - 微博记录中，没有当前的用户账号
     */
    /// 新增或者修改微博数据，微博数据再刷新的时候，可能会出现重叠
    ///
    /// - Parameters:
    ///   - userId: 当前登录用户的Id
    ///   - array: 从网络获取的‘字典数组’
    func updateStatus(userId: String, array: [[String: Any]]) {
        // 1. 准备SQL
        let sql = "INSERT OR REPLACE INTO T_Status (statusId, userId, status) VALUES (?, ?, ?)"
        
        // 2. 执行SQL
    }
}

// MARK: - 创建数据表以及其他私有方法
private extension SQLiteManager {
    //创建数据表
    func creatTable() {
        // 1. SQL
        guard let path = Bundle.main.path(forResource: "status.sql", ofType: nil), let sql = try? String(contentsOfFile: path) else {
            return
        }
        print(sql)
        
        // 2. 执行SQL,FMDB 的内部队列是串行队列，同步执行
        // 可以保证同一时间，只有一个任务操作数据库，从而保证数据库读写的安全
        queue.inDatabase { (db) in
            //只有在创表的时候，使用执行多条语句，可以一次创建多个数据表
            //在执行增删改的时候，一定不要使用statements方法，否则有可能会被注入
            if db.executeStatements(sql) == true {
                print("创表成功")
            }else {
                print("创表失败")
            }
        }
        print("OVER")
    }
}
