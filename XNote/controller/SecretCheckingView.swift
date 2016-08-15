//
//  SecretCheckingView.swift
//  XNote
//
//  Created by 郭达 on 16/8/10.
//  Copyright © 2016年 Guoda. All rights reserved.
//

import UIKit
import LocalAuthentication

protocol SecretCheckingDelegate {
    
    func fingerprintClick()
    
    func passwordClick()
}

class SecretCheckingView: UIView {

    var gd_delegate:SecretCheckingDelegate?
    var fingerprint:UIButton?
    var password:UIButton?
    var error:NSError?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    self.backgroundColor = UIColor.blackColor()
        self.alpha = 0.95
        self.createcheckingSystembutton()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("error")
    }
    func createcheckingSystembutton(){
        
        
        if #available(iOS 8.0, *) {
            #if true
                let authentication = LAContext()
                let isAvailable = authentication.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &error)
            #endif
            if  isAvailable{
                
                self.fingerprint = UIButton.init(type:.Custom)
                self.fingerprint?.frame = CGRect.init(x: 0, y: 0, width: 150, height: 30)
                self.fingerprint?.center = CGPoint.init(x: Width/2, y: Height/2 - 50)
                self.fingerprint?.addTarget(self, action: #selector(SecretCheckingView.fingerprintBtnClick(_:)), forControlEvents: .TouchUpInside)
                self.fingerprint?.setTitle("点击使用指纹解锁", forState: .Normal)
                self.fingerprint?.setTitleColor(UIColor.blueColor(), forState: .Normal)
                self.fingerprint?.titleLabel?.textAlignment = NSTextAlignment.Center
                self.addSubview(self.fingerprint!)
                
            }else{

                
            }
            
        } else {
            // Fallback on earlier versions

            
        }
        
        
        self.password = UIButton.init(type: .Custom)
        self.password?.frame = CGRect.init(x: 0, y: 0, width: 150, height: 30)
        self.password?.center = CGPoint.init(x: Width/2, y: Height/2+50)
        self.password?.addTarget(self, action: #selector(SecretCheckingView.passwordBtnClick(_:)), forControlEvents: .TouchUpInside)
        self.password?.setTitle("点击使用密码解锁", forState: .Normal)
        self.password?.setTitleColor(UIColor.blueColor(), forState: .Normal)
        self.password?.titleLabel?.textAlignment = NSTextAlignment.Center
        self.addSubview(self.password!)
        
        
        
        
    }
    func fingerprintBtnClick(button:UIButton) {
        
        self.gd_delegate?.fingerprintClick()
        
    }
    func passwordBtnClick(button:UIButton) {
    
        self.gd_delegate?.passwordClick()
        
    }
    
    
}
