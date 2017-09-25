//
//  SearchUltilities.swift
//  Muzic
//
//  Created by Michael Ngo on 1/17/17.
//

import Foundation
import UIKit
import MuzicFramework
import CoreData

class ApiService {
    static func getSuggestions(keyword: String, completed: @escaping ([String])->()) {
        let query = keyword.replacingOccurrences(of: " ", with: "+")
        let url = URL(string: SUGGEST_API_URL + query)!
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if error != nil {
                print(error ?? "There is an error in search query")
            } else {
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
            }
        }).resume()
    }
    
    static func search(keyword: String, completed: @escaping (([Media])->())) {
        let query = SEARCH_API_URL + keyword.replacingOccurrences(of: " ", with: "+").addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let url = URL(string: query)!
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if error != nil {
                print(error ?? "There is an error in search query")
            } else {
                do {
                    if let unwrappedData = data, let json = try JSONSerialization.jsonObject(with: unwrappedData, options: .mutableContainers) as? [String: AnyObject] {
                        var videos = [Media]()
                        if let items = json["items"] as? [[String: AnyObject]] {
                            var searchId = ""
                            for item in items {
                                let video = Media()
                                if let snippet = item["snippet"] as? [String: AnyObject], let title = snippet["title"] as? String, let id = item["id"] as? [String: String], let videoId = id["videoId"], let channel = snippet["channelTitle"] as? String {
                                    video.title = title
                                    video.channel = channel
                                    if videos.count == 0 {
                                        searchId += videoId
                                    } else {
                                        searchId += ",\(videoId)"
                                    }
                                    video.id = videoId
                                    if let thumbnails = snippet["thumbnails"] as? [String: AnyObject], let medium = thumbnails["medium"] as? [String: AnyObject], let imageUrl = medium["url"] as? String, let high = thumbnails["high"], let playerImageUrl = high["url"] as? String {
                                        video.imageUrl = imageUrl
                                        video.playerImageUrl = playerImageUrl
                                    }
                                    videos.append(video)
                                }
                            }
                            ApiService.getDetails(videos: videos, idString: searchId, completed: completed)
                        }
                    }
                } catch let jsonError {
                    print(jsonError)
                }
            }
        }).resume()
    }
    
    static func downloadMedia(media: Media, completed: @escaping (()->())) {
        if let appDelegate = UIApplication.shared.delegate as! AppDelegate? {
            let context = appDelegate.context
            let fetchRequest = NSFetchRequest<Item>(entityName: "Item")
            fetchRequest.predicate = NSPredicate(format: "id == %@", media.id!)
            do {
                let results = try context?.fetch(fetchRequest)
                if results?.count == 0 {
                    let item = Item(context: context!)
                    let fetchDownload: NSFetchRequest<Download> = Download.fetchRequest()
                    var download: Download?
                    do {
                        let arr = try context?.fetch(fetchDownload)
                        if arr?.count != 0 {
                            download = arr?.first
                        } else {
                            download = Download(context: context!)
                        }
                    } catch {
                        print("Cannot fetch download object")
                    }
                    item.id = media.id
                    item.isVideo = media.isVideo!
                    var url = URL(string: DOWNLOAD_VIDEO_API_URL + (media.id)!)
                    if !media.isVideo! {
                        url = URL(string: DOWNLOAD_AUDIO_API_URL + (media.id)!)
                    }
                    media.title = media.title?.replacingOccurrences(of: "/", with: "-")
                    item.title = media.title
                    item.channel = media.channel
                    let ext = media.isVideo! ? ".mp4" : ".mp3"
                    var destinationUrl = DOCUMENT_DIR_URL.appendingPathComponent(media.title! + ext)
                    if !FileManager.default.fileExists(atPath: (destinationUrl.path)) {
                        URLSession.shared.downloadTask(with: url!, completionHandler: { (dataUrl, response, error) in
                            if error != nil {
                                print(error ?? "There is a problem with api server")
                            } else {
                                do {
                                    if let unwrappedDataUrl = dataUrl {
                                        if let status = (response as? HTTPURLResponse)?.statusCode, status == 200 {
                                            do {
                                                try FileManager.default.moveItem(at: unwrappedDataUrl, to: destinationUrl)
                                                item.filePath = destinationUrl.path
                                                destinationUrl = PLAYER_IMAGE_DIR_URL.appendingPathComponent(media.title! + ".jpg")
                                                if !FileManager.default.fileExists(atPath: (destinationUrl.path)) {
                                                    ApiService.downloadPicture(urlString: media.playerImageUrl!, completed: { (imageUrl) in
                                                        do {
                                                            item.imgPath = destinationUrl.path
                                                            item.isArchived = false
                                                            item.isFavorited = false
                                                            download?.addToItems(item)
                                                            try FileManager.default.moveItem(at: imageUrl, to: destinationUrl)
                                                            try context?.save()
                                                            completed()
                                                        } catch let error {
                                                            print(error)
                                                        }
                                                    })
                                                } else {
                                                    print("File already exists")
                                                }
                                            } catch let writeError {
                                                print(writeError)
                                            }
                                        }
                                    }
                                }
                            }
                        }).resume()
                    }
                }
            } catch let err {
                print(err)
            }
        }
    }
    
    static func downloadPicture(urlString: String, completed: @escaping ((URL)->())) {
        let url = URL(string: urlString)!
        URLSession.shared.downloadTask(with: url, completionHandler: { (data, response, error) in
            if error != nil {
                print(error ?? "Error with image url")
            } else {
                if let imageUrl = data {
                    if let status = (response as? HTTPURLResponse)?.statusCode, status == 200 {
                        completed(imageUrl)
                    }
                }
            }
        }).resume()
    }
    
    static func downloadPreviewImage(urlString: String, videoId: String, completed: @escaping ((UIImage, String)->())) {
        let url = URL(string: urlString)!
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if error != nil {
                print(error ?? "Error with image url")
            } else {
                if let imageData = data {
                    let img = UIImage(data: imageData)
                    completed(img!, videoId)
                }
            }
        }).resume()
    }
    
    static func getDetails(videos: [Media], idString: String, completed: @escaping (([Media])->())) {
        let url = URL(string: CONTENT_DETAIL_API_URL + idString)!
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if error != nil {
                print(error ?? "Error with downloading content details")
            } else {
                var dict = [String: String]()
                do {
                    if let unwrappedData = data, let json = try JSONSerialization.jsonObject(with: unwrappedData, options: .mutableContainers) as? [String: AnyObject] {
                        if let items = json["items"] as? [[String: AnyObject]] {
                            for item in items {
                                if let id = item["id"] as? String, let content = item["contentDetails"] as? [String: AnyObject], var duration = content["duration"] as? String {
                                    duration = duration.replacingOccurrences(of: "PT", with: "").replacingOccurrences(of: "S", with: "").replacingOccurrences(of: "H", with: ":").replacingOccurrences(of: "M", with: ":")
                                    dict[id] = duration
                                }
                            }
                            for video in videos {
                                video.duration = dict[video.id!]
                            }
                            DispatchQueue.main.async {
                                completed(videos)
                            }
                        }
                    }
                } catch let error {
                    print(error)
                }
            }
        }).resume()
        DispatchQueue.main.async {
            completed(videos)
        }

    }
}
