//
//  Common.swift
//  airConditioner
//
//  Created by 杨培文 on 15/6/10.
//  Copyright (c) 2015年 杨培文. All rights reserved.
//

import UIKit

class Common: NSObject {
    static var client = TCPClient(addr: "192.168.8.8", port: 21098)
    
    static func t(buf:[UInt8])->String{
        var re = ""
        for b in buf{
            re+=bts(b)+" "
        }
        re+=" 长度:\(buf.count)"
        return re
    }
    
    static func bts(b:UInt8)->String{
        var table = ["0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F"]
        return "\(table[Int(b/16)])\(table[Int(b%16)])"
    }
    
    static func connect()->Bool{
        let (success, error) = client.connect(timeout: 7)
        if success{
            print("连接服务器成功")
        }
        return success
    }
    
    static func send(buf:[UInt8]){
        print("开始发送数据:\(t(buf))")
        let (succeed,error) = client.send(data: buf)
        if succeed{
            print("发送数据成功")
        }else{
            print("发送数据失败:\(error)")
        }
    }
    
    static func read()->[UInt8]{
        print("开始读取数据")
        if let re = client.read(1024*10){
            print("获取数据成功:\(t(re))")
            return re
        }else{
            print("获取数据失败")
            return []
        }
    }
    
    //线程执行代码,可以随意丢入任务,线程池自动管理
    static func xiancheng(code:dispatch_block_t){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), code)
    }
    //主线程,也就是UI线程,不可放耗时任务
    static func ui(code:dispatch_block_t){
        dispatch_async(dispatch_get_main_queue(), code)
    }
}
