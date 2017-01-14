//
//  MyCache.swift
//  Infodat
//
//  Created by Steven on 1/11/17.
//  Copyright © 2017 Nhuan Quang Company Limited. All rights reserved.
//

import Foundation

class MyCache : NSCache<AnyObject, AnyObject> {
    static let shareInstance = MyCache()
}
