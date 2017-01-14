//
//  DetailViewController.swift
//  Infodat
//
//  Created by Steven on 1/11/17.
//  Copyright © 2017 Nhuan Quang Company Limited. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController : UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var lbTitle: UILabel!
    @IBOutlet var txtDescription: UITextView!
    
    var dataDict : AnyObject?
    
    override var shouldAutorotate : Bool {
        return true
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.portrait ,UIInterfaceOrientationMask.portraitUpsideDown, UIInterfaceOrientationMask.landscape]
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
    
    override func viewDidLoad() {
        
    }
    
    override func viewDidLayoutSubviews () {
        let userDict = dataDict?["user"] as! [String:Any]
        let avatarDict = userDict["avatar_image"] as! [String:Any]
        let imgUrl = avatarDict["url"]! as! String
        
        self.imageView.imageFromServerURL(urlString: imgUrl)
        self.lbTitle.text = userDict["name"] as? String
        self.txtDescription.text = dataDict?["text"] as? String
    }
 }
