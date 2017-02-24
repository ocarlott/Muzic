//
//  Video.swift
//  Muzic
//
//  Created by Michael Ngo on 1/18/17.
//  Copyright © 2017 MIV Solution. All rights reserved.
//

import Foundation

public class Media: NSObject, NSCoding {
    
    public override init() {
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        if let title = aDecoder.decodeObject(forKey: "title") as! String? {
            self.title = title
        }
        if let id = aDecoder.decodeObject(forKey: "id") as! String? {
            self.id = id
        }
        if let imgUrl = aDecoder.decodeObject(forKey: "imageUrl") as! String? {
            self.imageUrl = imgUrl
        }
        if let channel = aDecoder.decodeObject(forKey: "channel") as! String? {
            self.channel = channel
        }
        if let filePath = aDecoder.decodeObject(forKey: "filePath") as! String? {
            self.filePath = filePath
        }
        if let imgPath = aDecoder.decodeObject(forKey: "imgPath") as! String? {
            self.imgPath = imgPath
        }
        if let playerImageUrl = aDecoder.decodeObject(forKey: "playerImgUrl") as! String? {
            self.playerImageUrl = playerImageUrl
        }
        
        self.isVideo = aDecoder.decodeBool(forKey: "isVideo")
        
        self.duration = aDecoder.decodeInteger(forKey: "duration")
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.title ?? "", forKey: "title")
        aCoder.encode(self.id ?? "", forKey: "id")
        aCoder.encode(self.imageUrl ?? "", forKey: "imageUrl")
        aCoder.encode(self.channel ?? "", forKey: "channel")
        aCoder.encode(self.filePath ?? "", forKey: "filePath")
        aCoder.encode(self.imgPath ?? "", forKey: "imgPath")
        aCoder.encode(self.playerImageUrl ?? "", forKey: "playerImgUrl")
        aCoder.encode(self.isVideo ?? false, forKey: "isVideo")
        aCoder.encode(self.duration ?? 0, forKey: "duration")
    }
    
    public var title: String?
    public var id: String?
    public var imageUrl: String?
    public var isVideo: Bool?
    public var channel: String?
    public var filePath: String?
    public var imgPath: String?
    public var playerImageUrl: String?
    public var duration: Int?
}
