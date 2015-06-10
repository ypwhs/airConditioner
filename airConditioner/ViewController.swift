//
//  ViewController.swift
//  airConditioner
//
//  Created by 杨培文 on 15/6/10.
//  Copyright (c) 2015年 杨培文. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        connect()
        Common.xiancheng({
            while(true){
                NSThread.sleepForTimeInterval(0.5)
                self.gettime2()
                self.getwendu2()
                self.getshidu2()
                self.getstate2()
            }
        })
    }
    
    func connect(){
        Common.xiancheng({
            Common.client = TCPClient(addr: self.ip.text, port: 8899)
            Common.connect()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var ip: UITextField!
    
    @IBAction func connect1(sender: AnyObject) {
        connect()
    }
    
    @IBOutlet weak var labelwendu: UILabel!
    func getwendu2(){
        Common.send([0x82])
        let data =  Common.read()
        let wendu = NSString(bytes: data, length: data.count, encoding: NSUTF8StringEncoding)
        Common.ui({
            self.labelwendu.text = wendu as String!
        })
        
    }
    
    @IBAction func getwendu(sender: AnyObject) {
        Common.xiancheng({
            self.getwendu2()
        })
    }
    @IBOutlet weak var labeltime: UILabel!
    @IBOutlet weak var labelshidu: UILabel!
    
    @IBAction func kaiguan(sender: AnyObject) {
        Common.send([0x85])
        Common.xiancheng({
            self.getstate2()
        })
    }
    
    func getshidu2(){
        Common.send([0x83])
        let data =  Common.read()
        let shidu = NSString(bytes: data, length: data.count, encoding: NSUTF8StringEncoding)
        Common.ui({
            self.labelshidu.text = shidu as String!
        })
    }
    
    @IBAction func getshidu(sender: AnyObject) {
        Common.xiancheng({
            self.getshidu2()
        })
    }
    
    @IBOutlet weak var labelstate: UILabel!
    
    func getstate2(){
        Common.send([0x84])
        let data =  Common.read()
        Common.ui({
            if NSString(bytes: data, length: data.count, encoding: NSUTF8StringEncoding) == "1"{
                self.labelstate.text = "开"
            }else {
                self.labelstate.text = "关"
            }
        })
    }
    @IBAction func getstate(sender: AnyObject) {
        Common.xiancheng({
            self.getstate2()
        })
    }
    
    func gettime2(){
        Common.send([0x81])
        let data =  Common.read()
        var time = NSString(bytes: data, length: data.count, encoding: NSUTF8StringEncoding)
        time = time?.stringByReplacingOccurrencesOfString("Current Time:", withString: "")
        time = time?.stringByReplacingOccurrencesOfString("\r\n", withString: "")
        Common.ui({
            self.labeltime.text = time as String!
        })
    }
    
    @IBAction func gettime(sender: AnyObject) {
        Common.xiancheng({
            self.gettime2()
        })
    }
}

