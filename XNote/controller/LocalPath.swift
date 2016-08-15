//
//  LocalPath.swift
//  XNote
//
//  Created by 郭达 on 16/8/9.
//  Copyright © 2016年 Guoda. All rights reserved.
//

import UIKit

class LocalPath: NSObject {

    var imgPaht:String?
    var timedate:String?
    
    class func getImgMessage() -> NSArray {
        
        let array = NSKeyedUnarchiver.unarchiveObjectWithFile(NoteMessage)
        if (array != nil) {
            let arr = array as! NSArray
            return arr
        }
        return NSArray()
    }
    class func saveImgMessage(array:NSArray) {
        NSKeyedArchiver.archiveRootObject(array, toFile: NoteMessage)
//        print(b)
        
    }
    //MARK:保存gdview
    class func save(view:GDView) {
        
        let date = NSDate()
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "yyy-MM-dd'-'HH:mm:ss.SSS"
        let strNowTime = timeFormatter.stringFromDate(date) as String
        
        let timepath = String(date.timeIntervalSince1970*1000)
        
        let image = UIImageExtension.captureWithView(view)
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
        
        self.saveImgMessage(mutableArray)

    }
    
}
