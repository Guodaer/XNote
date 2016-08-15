//
//  DetailImgVC.swift
//  XNote
//
//  Created by 郭达 on 16/8/9.
//  Copyright © 2016年 Guoda. All rights reserved.
//

import UIKit

class DetailImgVC: NoteRootController {

    var imgpath:String?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let imageView = UIImageView.init(frame: CGRect (x: 0, y: 64, width: Width, height: Height-64))
        imageView.image = UIImage.init(contentsOfFile: imgpath!)
        self.view.addSubview(imageView)
        
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
