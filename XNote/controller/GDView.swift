//
//  GDView.swift
//  XNote
//
//  Created by 郭达 on 16/8/8.
//  Copyright © 2016年 Guoda. All rights reserved.
//

import UIKit

class GDView: UIView {

    override init(frame: CGRect) {
        super.init(frame:frame)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("error")
    }
    
    func back() {
        self.paths.removeLastObject()
        self.setNeedsDisplay()
    }
    func clear() {
        self.paths.removeAllObjects()
        self.setNeedsDisplay()
        
    }
    override func drawRect(rect: CGRect) {
        for path in self.paths {
            path.stroke()
        }
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let path = UIBezierPath()
        path.lineCapStyle = CGLineCap.Round
        path.lineJoinStyle = CGLineJoin.Round
        path.lineWidth = 5
        let touch = (touches as NSSet).anyObject()
        path.moveToPoint((touch?.locationInView(self))!)
        self.paths.addObject(path)
        self.setNeedsDisplay()
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let path = self.paths.lastObject
        let touch = (touches as NSSet).anyObject()
        path!.addLineToPoint((touch?.locationInView(self))!)
        self.setNeedsDisplay()
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.touchesMoved(touches, withEvent: event)
    }
    //懒加载
    lazy var paths:NSMutableArray = {
        let tempArray = NSMutableArray()
        return tempArray
    }()

}
