//
//  MenuView.swift
//  XNote
//
//  Created by 郭达 on 16/8/9.
//  Copyright © 2016年 Guoda. All rights reserved.
//

import UIKit

protocol MenuViewDelegate {
    
    func menudidClick(item:NSInteger)
    func menuTapbackView()
}

class MenuView: UIView,UITableViewDelegate,UITableViewDataSource {

    let dataArray = ["手写笔记，涂鸦","普通笔记","设置，加密码锁"]
    var gd_delegate:MenuViewDelegate!
    var backView:UIView!
    var targetMenu:UIViewController!
    var tableView:UITableView?
    var headView:UIView!
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("error")
    }
    func setupTableView() {
        self.backView = UIView (frame: CGRect (x: 0, y: 0, width: Width, height: Height))
        self.backView.backgroundColor = UIColor.blackColor()
        self.backView.alpha = 0
        self.backView.userInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(MenuView.tap(_:)))
        self.backView.addGestureRecognizer(tap)
        self.targetMenu.view .addSubview(self.backView)
        
        self.headView = UIView (frame: CGRect (x: 0, y: 0, width: Width, height: 64))
        self.headView.backgroundColor = UIColor.clearColor()
        self.headView.alpha = 0
        self.headView.userInteractionEnabled = true
        let tap1 = UITapGestureRecognizer.init(target: self, action: #selector(MenuView.tap(_:)))
        self.headView.addGestureRecognizer(tap1)
        self.targetMenu.navigationController?.navigationBar.addSubview(self.headView)
        
        self.tableView = UITableView (frame: CGRect (x: 0, y: 0, width: self.frame.size.width, height: 44*3))
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.bounces = false
        self.tableView?.rowHeight = 44
        self.tableView?.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.addSubview(self.tableView!)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell" )
        
        if self.dataArray.count>0 {
            let titleLabel = UILabel (frame: CGRect (x: 0, y: 0, width: Width, height: 44))
            titleLabel.text = self.dataArray[indexPath.row]
            titleLabel.textColor = UIColor.redColor()
            titleLabel.numberOfLines = 0
            titleLabel.textAlignment = NSTextAlignment.Center
            cell!.addSubview(titleLabel)
            
        }

        return cell!
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            self.gd_delegate?.menudidClick(indexPath.row)
    }
    func tap(tap:UITapGestureRecognizer) {
    self.gd_delegate?.menuTapbackView()
    }
    func showMenuWithAnimation(isShow:Bool) {
        UIView.animateWithDuration(0.25, animations: { 
            
            if isShow {
                self.alpha = 1
                self.backView.alpha = 0.1
                self.headView.alpha = 0.1
                self.transform = CGAffineTransformMakeScale(1, 1)
            }else{
//                self.alpha = 0
//                self.backView.alpha = 0
                self.transform = CGAffineTransformMakeScale(1, 0.01)
            }
            
        }) { (Bool) in
            if !isShow{
                self.headView.removeFromSuperview()
                self.backView.removeFromSuperview()
                self.removeFromSuperview()
            }
        }
    }
    class func createMenu(frame:CGRect,target:UIViewController) ->MenuView {
        let menuView = MenuView.init(frame: frame)
        menuView.targetMenu = target
        menuView.setupTableView()
            
        menuView.layer.anchorPoint = CGPointMake(0.5, 0)
        menuView.layer.position = CGPointMake(Width/2, 64)
        menuView.transform = CGAffineTransformMakeScale(1, 0.01)
        
        target.view.addSubview(menuView)

        return menuView
    }
    
    
    
}
