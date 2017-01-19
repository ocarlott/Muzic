//
//  SearchUltilities.swift
//  Muzic
//
//  Created by Michael Ngo on 1/17/17.
//  Copyright © 2017 MIV Solution. All rights reserved.
//

import Foundation

class ApiService {
    static func getSuggestions(keyword: String, completed: @escaping ([String])->()) {
        let query = keyword.replacingOccurrences(of: " ", with: "+")
        let url = URL(string: SUGGEST_API_URL + query)!
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
    
    static func search(keyword: String, completed: @escaping (([Media])->())) {
        let query = keyword.replacingOccurrences(of: " ", with: "+")
        let url = URL(string: SEARCH_API_URL + query)!
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if error != nil {
                print(error ?? "There is an error in search query")
            }
            do {
                if let unwrappedData = data, let json = try JSONSerialization.jsonObject(with: unwrappedData, options: .mutableContainers) as? [String: AnyObject] {
                    var videos = [Media]()
                    if let items = json["items"] as? [[String: AnyObject]] {
                        for item in items {
                            let video = Media()
                            if let snippet = item["snippet"] as? [String: AnyObject], let title = snippet["title"] as? String, let id = item["id"] as? [String: String], let videoId = id["videoId"], let channel = snippet["channelTitle"] as? String {
                                video.title = title
                                video.channel = channel
                                video.id = videoId
                                if let thumbnails = snippet["thumbnails"] as? [String: AnyObject], let medium = thumbnails["medium"] as? [String: AnyObject], let imageUrl = medium["url"] as? String {
                                    video.imageUrl = imageUrl
                                }
                                videos.append(video)
                            }
                        }
                        DispatchQueue.main.async {
                            completed(videos)
                        }
                    }
                }
            } catch let jsonError {
                print(jsonError)
            }
        }).resume()
    }
}
