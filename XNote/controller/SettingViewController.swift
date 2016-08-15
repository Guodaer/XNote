//
//  SettingViewController.swift
//  XNote
//
//  Created by 郭达 on 16/8/10.
//  Copyright © 2016年 Guoda. All rights reserved.
//

import UIKit
import LocalAuthentication

class SettingViewController: NoteRootController,UITableViewDelegate,UITableViewDataSource {

    
    var dataArray: NSMutableArray?
    var error:NSError?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 8.0, *) {
            #if true
            let authentication = LAContext()
            let isAvailable = authentication.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &error)
            #endif
            if  isAvailable{
                self.dataArray = NSMutableArray.init(array: ["开启密码锁","开启指纹锁"])
            }else{
                self.dataArray = NSMutableArray.init(array: ["开启密码锁"])
                
            }
            
        } else {
            // Fallback on earlier versions
            self.dataArray = NSMutableArray.init(array: ["开启密码锁"])

        }
        
        self.view.addSubview(self.tableView)
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.dataArray?.count)!
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.whiteColor()
        return view
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell")
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        }
        for sub in (cell?.subviews)! {
            sub.removeFromSuperview()
        }
        
        cell?.selectionStyle = UITableViewCellSelectionStyle.None
        let label = UILabel.init(frame: CGRect (x: 20, y: 0, width: 100, height: 44))
        label.text = self.dataArray?[indexPath.row] as? String
        label.textColor = UIColor.blackColor()
        label.font = UIFont.systemFontOfSize(15)
        cell?.addSubview(label)

        let switchBtn = UISwitch.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 44))
        switchBtn.center = CGPoint.init(x: Width-40, y: 22)
        switchBtn.tag = indexPath.row
        cell?.addSubview(switchBtn)
        switchBtn.addTarget(self, action: #selector(SettingViewController.switchSelected(_:)), forControlEvents: UIControlEvents.ValueChanged)
        switchBtn.on = false
        let sec1 = NSUserDefaults.standardUserDefaults().objectForKey("secret_1")
        if sec1 != nil {
            if indexPath.row == 0 {
                let sec_State = sec1 as! String
                if sec_State == "on" {
                    switchBtn.on = true
                }else {switchBtn.on = false
                }
            }
        }else{
            if indexPath.row == 0 {
                switchBtn.on = false
            }
        }
        
        let sec2 = NSUserDefaults.standardUserDefaults().objectForKey("secret_2")
        if sec2 != nil {
            if indexPath.row == 1 {
                let sec_State = sec2 as! String
                if sec_State == "on" {
                    switchBtn.on = true
                }else {switchBtn.on = false
                }
            }
        }else{
            if indexPath.row == 1 {
                switchBtn.on = false
            }
        }

        
        return cell!
    }
    func switchSelected(myswitch:UISwitch){
        
        if myswitch.tag == 0 {
            if myswitch.on {
                NSUserDefaults.standardUserDefaults().setObject("on", forKey: "secret_1")
                self.inputpassword()
            }else{
                NSUserDefaults.standardUserDefaults().setObject("off", forKey: "secret_1")
                NSUserDefaults.standardUserDefaults().removeObjectForKey("secret_password")
            }
            
        }else{
            print("指纹")
        }
    
    }
    func inputpassword() {
        if #available(iOS 8.0, *) {
            let alertVC = UIAlertController(title: "请输入密码", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            alertVC.addTextFieldWithConfigurationHandler({ (textfield:UITextField) in
                textfield.placeholder = "请输入密码"
                textfield.secureTextEntry = true
            })
            
            let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: { (UIAlertAction) in
                NSUserDefaults.standardUserDefaults().removeObjectForKey("secret_password")
                NSUserDefaults.standardUserDefaults().setObject("off", forKey: "secret_1")
                    self.tableView.reloadData()
            })
            let okAction = UIAlertAction(title: "好的", style: .Default,handler: {action in
                let password = alertVC.textFields!.first! as UITextField
                if (password.text != nil)&&(password.text != "") {
                    NSUserDefaults.standardUserDefaults().setObject(password.text, forKey: "secret_password")
                }else{
                    NSUserDefaults.standardUserDefaults().removeObjectForKey("secret_password")
                    NSUserDefaults.standardUserDefaults().setObject("off", forKey: "secret_1")
                        self.tableView.reloadData()
                }
            })
            alertVC.addAction(cancelAction)
            alertVC.addAction(okAction)
            alertVC.view.setNeedsLayout()//这句话非常重要
            self.presentViewController(alertVC, animated: true, completion: nil)

        } else {
            // Fallback on earlier versions
        }
    }
    //MARK:懒加载
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: Width, height: Height))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.bounces = false
        
//        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
