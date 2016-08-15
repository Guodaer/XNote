//
//  CollectionViewCell.swift
//  XNote
//
//  Created by 郭达 on 16/8/10.
//  Copyright © 2016年 Guoda. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    var imageView:UIImageView?
    var deleteImg:UIImageView?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createCellView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("error")
    }
    
    func createCellView(){
    
        self.imageView = UIImageView.init(frame: CGRect (x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        self.addSubview(self.imageView!)
    
        self.deleteImg = UIImageView.init(frame: CGRect (x: 0, y: 0, width: 25, height: 25))
        self.deleteImg?.image = UIImage.init(named: "collectiondelete")
        self.addSubview(self.deleteImg!)
        
    }
    func state_Edit(editdelete:NSInteger){
        if editdelete == 1 {
            UIView.animateWithDuration(0.2, animations: {
                self.transform=CGAffineTransformMakeRotation(-0.02)
                
                }, completion: { (Bool) in
                    UIView.animateWithDuration(0.2, delay: 0, options: [UIViewAnimationOptions.Autoreverse,UIViewAnimationOptions.Repeat,UIViewAnimationOptions.AllowUserInteraction], animations: {
                        self.transform=CGAffineTransformMakeRotation(0.02)
                        }, completion: nil)
            })
        }else{
            UIView.animateWithDuration(0.1, delay: 0, options: [UIViewAnimationOptions.BeginFromCurrentState,UIViewAnimationOptions.AllowUserInteraction], animations: {
                self.transform=CGAffineTransformIdentity;
                }, completion: nil)
        }
    }
    
}
