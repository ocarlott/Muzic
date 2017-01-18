//
//  SearchUltilities.swift
//  Muzic
//
//  Created by Michael Ngo on 1/17/17.
//  Copyright © 2017 MIV Solution. All rights reserved.
//

import Foundation

class SearchUtilities {
    static func getSuggestions(keyword: String, completed: @escaping ([String])->()) {
        let query = keyword.replacingOccurrences(of: " ", with: "+")
        let url = URL(string: SUGGEST_API + query)!
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if error != nil {
                print(error ?? "There is an error in search query")
            }
            do {
                if let unwrappedData = data {
                    var strData = String(data: unwrappedData, encoding: .utf8)
                    strData = strData?.replacingOccurrences(of: "window.google.ac.h(", with: "")
                    strData = strData?.replacingOccurrences(of: ")", with: "")
                    let cleanData = strData?.data(using: String.Encoding.utf8)
                    var suggestions = [String]()
                    if let cData = cleanData {
                        let json = try JSONSerialization.jsonObject(with: cData, options: .mutableContainers) as? [AnyObject]
                        if let list = json?[1] as? [[AnyObject]] {
                            for item in list {
                                if let text = item[0] as? String {
                                    suggestions.append(text)
                                }
                            }
                            DispatchQueue.main.async {
                                completed(suggestions)
                            }
                        }
                    }
                }
            } catch let jsonError {
                print(jsonError)
            }
        }).resume()
    }
    
    static func search(keyword: String) {
        print(keyword)
    }
}
