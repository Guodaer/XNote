//
//  UIImageExtension.swift
//  XNote
//
//  Created by 郭达 on 16/8/8.
//  Copyright © 2016年 Guoda. All rights reserved.
//

import UIKit
extension UIImage {
    
    class func captureWithView(view:UIView) -> UIImage{

        // 1.开启上下文
        UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 0.0);
        
        // 2.将控制器view的layer渲染到上下文
        view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        
        // 3.取出图片
        let newImage = UIGraphicsGetImageFromCurrentImageContext() as UIImage
        
        // 4.结束上下文
        UIGraphicsEndImageContext();
    
        return newImage
        
    }
    //压缩图片
    class func resizeImage(path:String) -> UIImage {
        let image = UIImage.init(contentsOfFile: path)
        let size = CGSize (width: (Width-80)/4, height: (Width-80)/4*(Height-64)/Width)
        UIGraphicsBeginImageContext(size)
        image?.drawInRect(CGRect (x: 0, y: 0, width: size.width, height: size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    
    
}
class UIImageExtension: UIImage {

}
