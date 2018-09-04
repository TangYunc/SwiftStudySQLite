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
//"idstr": "(.*?)", "text": "微博-.*?"
//"idstr": "$1", "text": "微博-$1"
// MARK: - 微博数据操作
extension SQLiteManager {
    
    /// 从数据库加载 微博数据数组
    ///
    /// - Parameters:
    ///   - userId: 当前登录的用户账号
    ///   - since_id: 返回ID比since_id大的微博
    ///   - max_id: 返回ID比max_id小的微博
    /// - Returns: 微博的字典的数组，将数据库中 status 字段对应二进制数据反序列化，生成字典
    func loadStatus(userId: String, since_id: Int64 = 0, max_id: Int64 = 0) -> [[String: Any]] {
        //1.准备SQL
        var sql = "SELECT statusId, userId, status FROM T_Status \n"
        sql += "WHERE userId = \(userId) \n"
        //上拉 / 下拉,都是针对同一个id 进行判断
        if since_id > 0 {
            sql += "AND statusId > \(since_id) \n"
        } else if max_id < 0 {
            sql += "AND statusId < \(max_id) \n"
        }
        sql += "ORDER BY statusId DESC LIMIT 20;"
        //拼接SQL结束后，一定要测试SQL的正确性
        print(sql)
        return []
    }
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
        queue.inTransaction { (db, rollback) in
            //遍历数组，逐条插入微博数据
            for dict in array {
                //从字典中获取微博代号/将字典序列化
                guard let statusId = dict["idstr"] as? String, let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: []) else {
                    continue
                }
                //执行SQL
                if db.executeUpdate(sql, withArgumentsIn: [statusId, userId, jsonData]) == false {
                    //需要回滚 *rollback = YES
                    //Xcode的自动语法转换，不会处理此处
                    //Swift 1.x & 2.x => rollback.memory = true
                    //Swift 3.0的写法
                    rollback.pointee = true
                    break
                }
                //默拟会滚
//                rollback.pointee = true
//                break
            }
        }
    }
}

extension SQLiteManager {
    
    func execRecordSet(sql: String) -> [[String: Any]] {
        
        var result = [[String: Any]]()
        
        //执行SQL - 查询数据，不会修改数据，所以不需要开启事务
        //事物的目的，是为了保证数据的有效性，一旦失败，回滚到初始状态
        queue.inDatabase { (db) in
           guard let rs = db.executeQuery(sql, withArgumentsIn: []) else {
                return
            }
            while rs.next() {
                //1> 列数
                let colCount = rs.columnCount
                //2> 遍历所有列
                for col in 0..<colCount {
                    //3> 列名 -> Key / 值 -> Value
                    guard let name = rs.columnName(for: col), let value = rs.object(forColumnIndex: col) else {
                        continue
                    }
                    print("\(name) - \(value)")
                    //4> 追加结果
                    result.append([name: value])
                }
            }
        }
        return result
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
