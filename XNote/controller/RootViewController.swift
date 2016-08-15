//
//  RootViewController.swift
//  XNote
//
//  Created by 郭达 on 16/8/5.
//  Copyright © 2016年 Guoda. All rights reserved.
//

import UIKit
import LocalAuthentication

class RootViewController: NoteRootController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,MenuViewDelegate,SecretCheckingDelegate {

    var rootCollectioonView:UICollectionView?
    var dataArray:NSMutableArray?
    var menuView:MenuView?
    var EditDelete:NSInteger?
//    var secretView:UIView?
    var secretcheckView:SecretCheckingView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.EditDelete = 0
        self.dataArray = NSMutableArray()
        self.refreshdata()
        self.setUpCollectionView()
        self.addNewNote()

        self.createsecretView()
        
    }
    
    //delegate
    func passwordClick() {
        self.passworddeblocking()
    }
    func fingerprintClick() {
        self.fingerprintdeblocking()
    }
    //MARK:密码
    func passworddeblocking(){
        
        if #available(iOS 8.0, *) {
            let alertVC = UIAlertController.init(title: "请输入密码", message: nil, preferredStyle:UIAlertControllerStyle.Alert)
            
            alertVC.addTextFieldWithConfigurationHandler({ (textfield:UITextField) in
                textfield.placeholder = "请输入密码"
            })
            let cancel = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.Cancel, handler: { (UIAlertAction) in
                
            })
            alertVC.addAction(cancel)
            
            let sure = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) in
                
                let password = alertVC.textFields!.first! as UITextField
                let localpassword =  NSUserDefaults.standardUserDefaults().objectForKey("secret_password") as! String
                if password.text == localpassword {
                    //解锁，view消失
                    self.secretDisappear()
                }
            
            })
            alertVC.addAction(sure)
            alertVC.view.setNeedsLayout()
            self.presentViewController(alertVC, animated: true, completion: nil)
            
        } else {
            // Fallback on earlier versions
        }
        
        
    }
    //MARK:指纹
    func fingerprintdeblocking(){
        //832
        if #available(iOS 8.0, *){
            let context = LAContext()
            var error : NSError?
            let reasonString = "XNote的Touch ID"
            if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &error) {
                context.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString, reply: { (success:Bool, evalPolicyError:NSError?) in
                    dispatch_async(dispatch_get_main_queue(), { 
                        
                        if success{
                            self.secretDisappear()
                        }else{
                        
                        }
                        
                        
                    })
                })
            }
        
        }
    
    }
    //MARK:secret—view消失
    func secretDisappear(){
        UIView.animateWithDuration(0.3, animations: { 
            self.secretcheckView.alpha = 0
            }) { (Bool) in
                self.secretcheckView .removeFromSuperview()
                self.secretcheckView = nil
        }
        
    }
    
    func createsecretView() {
        //判断是否需要密码
        let localState = NSUserDefaults.standardUserDefaults().objectForKey("secret_1")
        if localState != nil {
            let sec1 = localState as? String
            if sec1 == "on" {
                self.secretcheckView = SecretCheckingView.init(frame: CGRect.init(x: 0, y: 0, width: Width, height: Height))
                self.secretcheckView.gd_delegate = self
//                let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
                self.view.addSubview(self.secretcheckView!)
            }
        }
        
    }
    //MARK:刷新数据
    func refreshdata() {
        let array = LocalPath.getImgMessage()
        self.dataArray = NSMutableArray (array: array)
        self.rootCollectioonView?.reloadData()

    }
    //MARK:创建视图collectionView
    func setUpCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.Vertical
        self.rootCollectioonView = UICollectionView (frame: CGRect (x: 0, y: 0, width:Width , height: Height), collectionViewLayout: layout)
        self.rootCollectioonView?.delegate = self
        self.rootCollectioonView?.dataSource = self
        self.rootCollectioonView?.registerClass(CollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        self.view.addSubview(self.rootCollectioonView!)
        
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.dataArray?.count)!
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CollectionViewCell
        if dataArray?.count>0 {

            let dic = self.dataArray![indexPath.row] as! NSDictionary
            let imgPath = dic.objectForKey("imgpath") as! String
            let path = NoteSavePath + "/" + imgPath
            /*这占内存老大了，用新方法，压缩一下
            let data = NSData(contentsOfFile:path)
            image.image = UIImage.init(data: data!)
            */
            cell.imageView!.image = UIImage.resizeImage(path)
            if self.EditDelete ==  1{
                cell.state_Edit(1)
            cell.deleteImg?.hidden = false
            }else{
                cell.state_Edit(0)
                cell.deleteImg?.hidden = true
            }
            
        }
        
        return cell
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake((Width-80)/4, (Width-80)/4*(Height-64)/Width)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(20, 20, 20, 20)
    }
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let dic = self.dataArray![indexPath.row] as! NSDictionary
        let imgPath = dic.objectForKey("imgpath") as! String
        let path = NoteSavePath + "/" + imgPath

        if self.EditDelete == 1 {
            self.dataArray?.removeObjectAtIndex(indexPath.row)
            LocalPath.saveImgMessage(self.dataArray!)
            self.rootCollectioonView?.deleteItemsAtIndexPaths([indexPath])
            
        }else{
            let detail = DetailImgVC()
            detail.imgpath = path
            self.navigationController?.pushViewController(detail, animated: true)
        }
        
    }
    //MARK:导航栏按钮
    func addNewNote() {
        let add = UIButton(type:.Custom)
        add.frame = CGRect (x: 0, y: 0, width: 40, height: 20)
        add.setTitle("添加", forState: UIControlState.Normal)
        add.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        add.titleLabel?.font = UIFont.systemFontOfSize(15)
        add.addTarget(self, action: #selector(RootViewController.unfoldMenu(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        let leftItem = UIBarButtonItem(customView: add)
        self.navigationItem.leftBarButtonItem = leftItem
        
        let edit = UIButton (type: .Custom)
        edit.tag = 1000
        edit.frame = CGRect (x: 0, y: 0, width: 40, height: 20)
        edit.setTitle("编辑", forState: UIControlState.Normal)
        edit.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        edit.titleLabel?.font = UIFont.systemFontOfSize(15)
        edit.addTarget(self, action: #selector(RootViewController.editBtnClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        let rightItem = UIBarButtonItem (customView: edit)
        self.navigationItem.rightBarButtonItem = rightItem
        
        
    }
    //MARK:编辑
    func editBtnClick(button:UIButton) {
    
        let editBtn = self.navigationItem.rightBarButtonItem?.customView as! UIButton
        if self.EditDelete == 0 {
            self.EditDelete = 1
            self.rootCollectioonView?.reloadData()
            editBtn.setTitle("完成", forState: UIControlState.Normal)
        }else{
            self.EditDelete = 0
            self.rootCollectioonView?.reloadData()
            editBtn.setTitle("编辑", forState: UIControlState.Normal)

        }
    }
    
    //MARK:添加
    func unfoldMenu(button:UIButton) {
        if ((self.menuView) != nil) {
            self.menuView?.removeFromSuperview()
        }
        self.menuView = MenuView.createMenu(CGRect (x: 0, y: 64, width: Width, height: 44*3), target: self)
        self.menuView?.gd_delegate = self
        self.menuView?.showMenuWithAnimation(true)
    }
    //MARK:点击tableview选项
    func menudidClick(item: NSInteger) {
        switch item {
        case 0:
            self.menuView?.showMenuWithAnimation(false)
            self.navigationController?.pushViewController(DrawImageVC(), animated: true)
            break
        case 2:
            self.menuView?.showMenuWithAnimation(false)
            self.navigationController?.pushViewController(SettingViewController(), animated: true)
        default: break
        }

    }
    func menuTapbackView() {
        self.menuView?.showMenuWithAnimation(false)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        self.refreshdata()
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
