//
//  DataManager.swift
//  Reddit
//
//  Created by Augusto Valdez Barrios on 24/4/17.
//  Copyright © 2017 isy. All rights reserved.
//

import UIKit

 let redditJson = "https://www.reddit.com/top/.json"


class DataManager: NSObject {
    
    public class func loadDataFromURL(url: URL, completion: @escaping (_ data: Data?, _ error: Error?) -> Void) {
        let loadDataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                completion(nil, error)
            } else if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    let statusError = NSError(domain: "com.reddit",
                                              code: response.statusCode,
                                              userInfo: [NSLocalizedDescriptionKey: "HTTP status code has unexpected value."])
                    completion(nil, statusError)
                } else {
                    completion(data, nil)
                }
            }
        }
        loadDataTask.resume()
    }
    

    public class func getTop25EntriesFromRedditWithSuccess(success: @escaping ((_ RedditData: Data) -> Void)) {
        //1
        loadDataFromURL(url: URL(string: redditJson)!) { (data, error) -> Void in
            //2
            if let data = data {
                //3
                success(data)
            }
        }
    }
    
    
    
}
