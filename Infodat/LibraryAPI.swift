//
//  LibraryAPI.swift
//  BuzzFizz
//
//  Created by Steven on 1/9/17.
//  Copyright © 2017 Nhuan Quang Company Limited. All rights reserved.
//

import Foundation

enum HTTPStatus {
    case Successful
    case Fail
}

protocol LibraryAPIProtocol : class {
    func didFinishLoadData(data: AnyObject?)
}

/**
 This class is a facade to handle event's calling in our app.
 */

class LibraryAPI {
    
    weak var delegate : LibraryAPIProtocol?
    
    static let shareLibraryAPI = LibraryAPI()
    
    /**
     This method will make a request to the server and return the json result.
     
     - Parameter viewController: this is callback params where we want it will redirect after finishing loading data.
     
     - Returns: Void
     */
    func loadDataFromServer() -> Void {
        let urlPath = URL(string: "https://alpha-api.app.net/stream/0/posts/stream/global")
        
        let task = URLSession.shared.dataTask(with: urlPath! as URL) { data, response, error in
            
            guard let data = data, error == nil else { return }
            
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    let data = jsonResult["data"]
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.delegate?.didFinishLoadData(data: data as AnyObject?)
                    })
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
        task.resume()
    }
    
}
