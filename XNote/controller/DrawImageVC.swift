//
//  DrawImageVC.swift
//  XNote
//
//  Created by 郭达 on 16/8/8.
//  Copyright © 2016年 Guoda. All rights reserved.
//

import UIKit

class DrawImageVC: NoteRootController,UIAlertViewDelegate {

    var gdView:GDView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        gdView = GDView.init(frame: CGRect (x: 0, y: 64, width: Width, height: Height-64))
        gdView?.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(gdView!)
        self.navigationbackButton()
        
    }
    
    //MARK:导航栏按钮
    func navigationbackButton() {
        
        let goback = UIButton(type:.Custom)
        goback.frame = CGRect (x: 0, y: 0, width: 13, height: 20)
        goback.setImage(UIImage.init(named: "popBack"), forState: UIControlState.Normal)
        goback.addTarget(self, action: #selector(DrawImageVC.btnBackClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        let leftItem = UIBarButtonItem(customView: goback)
        self.navigationItem.leftBarButtonItem = leftItem
        
        let clear = UIButton.init(type: UIButtonType.Custom)
        clear.setTitle("清除", forState: UIControlState.Normal)
        clear.frame = CGRect.init(x: 0, y: 0, width: 40, height: 30)
        clear.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        clear.titleLabel?.font = UIFont.systemFontOfSize(15)
        clear.addTarget(self, action: #selector(DrawImageVC.clearButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        let right1 = UIBarButtonItem (customView: clear)
        
        let back = UIButton.init(type: UIButtonType.Custom)
        back.frame = CGRect.init(x: 0, y: 0, width: 40, height: 30)
        back.setTitle("撤回", forState: UIControlState.Normal)
        back.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        back.titleLabel?.font = UIFont.systemFontOfSize(15)
        back.addTarget(self, action: #selector(DrawImageVC.backButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        let right2 = UIBarButtonItem.init(customView: back)
        
        self.navigationItem.rightBarButtonItems = [right2,right1]
        
    }
    func clearButton(button:UIButton) {
        self.gdView?.clear()
    }
    func backButton(button:UIButton) {
        self.gdView?.back()
    }
    func btnBackClick(button:UIButton) {
        if #available(iOS 8.0, *) {
            let alertVC = UIAlertController.init(title: "是否保存", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            let alert1 = UIAlertAction.init(title: "否", style: UIAlertActionStyle.Cancel, handler: { (UIAlertAction) in
                self.performSelector(#selector(DrawImageVC.popVC), withObject: nil, afterDelay: 0.2)
            })
            alertVC.addAction(alert1)
            
            let alert2 = UIAlertAction.init(title: "保存", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) in
                
                //保存到沙盒
                self.save()
                self.performSelector(#selector(DrawImageVC.popVC), withObject: nil, afterDelay: 0.2)

            })
            alertVC.addAction(alert2)
            self.presentViewController(alertVC, animated: true, completion: nil)

        } else {
            // Fallback on earlier versions
            
            
        }
        
    }
    func popVC() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    //MARK:保存
    func save() {
        LocalPath.save(self.gdView!)
        #if false
        let date = NSDate()
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "yyy-MM-dd'-'HH:mm:ss.SSS"
        let strNowTime = timeFormatter.stringFromDate(date) as String
        
        let timepath = String(date.timeIntervalSince1970*1000)
        
        let image = UIImageExtension.captureWithView(self.gdView!)
        let imageData = UIImagePNGRepresentation(image)
        let path = NoteSavePath + "/" + timepath
        imageData?.writeToFile(path, atomically: true)
        
        
        let localpath = LocalPath()
        localpath.imgPaht = timepath
        localpath.timedate = strNowTime
        
        //键值对  imgpath   datetime
        let array = LocalPath.getImgMessage()
        let mutableArray = NSMutableArray (array: array)

        let dic:Dictionary<String,String>= ["imgpath":localpath.imgPaht!,"timedate":localpath.timedate!]
        
        mutableArray.addObject(dic)

        LocalPath.saveImgMessage(mutableArray)
        #endif
    }
    //MARK:保存到相册
    func SaveNoteToLocalAlbum() {
        let image = UIImageExtension.captureWithView(self.gdView!)
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(DrawImageVC.image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
        if (error != nil) {
            MBProgressHUD.showError("保存失败")
        } else {
            MBProgressHUD.showSuccess("保存成功")
        }
    }

    
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
