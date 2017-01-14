//
//  ViewController.swift
//  Infodat
//
//  Created by Steven on 12/14/16.
//  Copyright © 2016 Nhuan Quang Company Limited. All rights reserved.
//

import UIKit

enum StringError:Error {
    case empty
    case invalidLength
    case atLeastOneNumber
    case atLeastOneUpperCase
    case noSpecialCharacters
}



class LoginViewController: UIViewController {

    @IBOutlet var txtUsername: UITextField!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var btnLogin: UIButton!
    @IBOutlet var lbError: UILabel!
    
    @IBAction func handleLogin(_ sender: AnyObject) {
//        if (txtUsername.text?.isEmpty == true) {
//            self.handleErrorLabel("* The username must not be blank")
//            return
//        }
//        
//        do {
//            try txtPassword.text?.checkValidPassword()
//            
//            lbError.hidden = true
        
            //login success
        self.performSegue(withIdentifier: "loginSuccess", sender: self)
        
//        } catch StringError.Empty {
//            self.handleErrorLabel("* The password must not be blank")
//        } catch StringError.InvalidLength {
//            self.handleErrorLabel("* The password must have at least 7 characters")
//        } catch StringError.AtLeastOneNumber {
//            self.handleErrorLabel("* The password must have at least 1 number")
//        } catch StringError.AtLeastOneUpperCase {
//            self.handleErrorLabel("* The password must have at least 1 upper case character")
//        } catch StringError.NoSpecialCharacters {
//            self.handleErrorLabel("* The password must have no special characters")
//        }
//        catch {
//            //do anything
//        }
    }
    
    func handleErrorLabel(_ message: String?) -> Void {
        lbError.text = message
        lbError.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        lbError.isHidden = true;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true;
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false;
    }
    
    override func viewDidLayoutSubviews () {
        self.initSetupViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func initSetupViews() -> Void {
        self.setLoginButtonStyle()
    }
    
    func setLoginButtonStyle() -> Void {
        btnLogin.titleLabel?.textColor = UIColor.white
        
        btnLogin.layer.cornerRadius  = 5;
        btnLogin.layer.masksToBounds = true;
        btnLogin.contentMode = UIViewContentMode.scaleAspectFill
        
        btnLogin.setBackgroundImage(Utility.imageFromColor(UIColor.green), for: UIControlState())
        btnLogin.setBackgroundImage(Utility.imageFromColor(UIColor.lightGray), for: UIControlState.highlighted)
    
        let maskPath = UIBezierPath(roundedRect: btnLogin.bounds, byRoundingCorners: [UIRectCorner.bottomLeft,UIRectCorner.bottomRight,UIRectCorner.topLeft,UIRectCorner.topRight], cornerRadii: CGSize(width: 5.0, height: 5.0))
        
        let maskLayer : CAShapeLayer = CAShapeLayer()
        maskLayer.path  = maskPath.cgPath;
        self.btnLogin.layer.mask = maskLayer;
    }
}

