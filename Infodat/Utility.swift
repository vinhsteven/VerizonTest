//
//  Utility.swift
//  Infodat
//
//  Created by Steven on 12/14/16.
//  Copyright © 2016 Nhuan Quang Company Limited. All rights reserved.
//

import Foundation
import UIKit

/**
 This class provide static instance to handle some special tasks such extension from other data type, define utilitzed method.
 */

class Utility {
    /**
     It converts UIColor to UIImage.
     
     This method accepts a UIColor value and convert it to UIImage values
     To use it, simply call Utility.imageFromColor(UIColor.white)
     
     - Parameter _: the input presenting for UIColor value.
     
     - Returns:  UIImage.
     */
    static func imageFromColor(_ color : UIColor) -> UIImage {
        let rect : CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context : CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor);
        context.fill(rect);
        let img : UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        return img;
    }
}

extension String {
    func checkValidPassword() throws {
        //check string if it is empty
        if self.isEmpty {
            throw StringError.empty
        }
        
        //check validate for password length
        let validLength = try NSRegularExpression(pattern: "^.{7,}$", options: [NSRegularExpression.Options.caseInsensitive])
        if validLength.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, characters.count)) != nil
        {
            print("Match length")
        }
        else {
            throw StringError.invalidLength
        }
        
        //check validate for
        let atLeastOneNumber = try NSRegularExpression(pattern: "(?=.*?[0-9])", options: [NSRegularExpression.Options.caseInsensitive])
        if atLeastOneNumber.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, characters.count)) != nil
        {
            print("Match at least 1 number")
        }
        else {
            throw StringError.atLeastOneNumber
        }
        
        let atLeastOneUpperCase = try NSRegularExpression(pattern: "(?=(.*[A-Z]))", options:NSRegularExpression.Options(rawValue:0))
        if atLeastOneUpperCase.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, characters.count)) != nil
        {
            print("Match at least 1 upper case")
        }
        else {
            throw StringError.atLeastOneUpperCase
        }
        
        let noSpecialCharacters = try NSRegularExpression(pattern: ".*[^A-Za-z0-9].*", options:NSRegularExpression.Options(rawValue:0))
        if noSpecialCharacters.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, characters.count)) != nil
        {
            throw StringError.noSpecialCharacters
        }
        else {
            print("Match no special characters")
        }
    }
}

extension UIImageView {
    public func imageFromServerURL(urlString: String) {
        if let cachedData = MyCache.shareInstance.object(forKey: urlString as AnyObject) {
            self.image = UIImage(data: cachedData as! Data)
        }
        else {
            URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
                
                if error != nil {
                    print(error as Any)
                    return
                }
                DispatchQueue.main.async(execute: { () -> Void in
                    self.image = UIImage(data: data!)
                    MyCache.shareInstance.setObject(data! as AnyObject, forKey: urlString as AnyObject)
                })
            }).resume()
        }
    }
}

extension Array where Element: Hashable {
    var distinct: [Element] {
        return Array(Set(self))
    }
}
