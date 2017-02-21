//
//  LinkedList.swift
//  Muzic
//
//  Created by Michael Ngo on 2/17/17.
//  Copyright © 2017 MIV Solution. All rights reserved.
//

import Foundation
import AVFoundation

public class LLNode<T> {
    var key: T?
    var next: LLNode?
    var prev: LLNode?
}

public class List<T> {
    
    private var head: LLNode<T>?
    private var tail: LLNode<T>?
    private var current: LLNode<T>?
    private var count = 0
    
    public init() {}
    
    public func add(key: T) {
        
        if head == nil {
            head = LLNode<T>()
            head?.key = key
            current = head
            return
        }
        
        let newNode = LLNode<T>()
        newNode.key = key
        newNode.prev = current
        current?.next = newNode
        current = newNode
        tail = newNode
    }
    
    public func getCurrentKey() -> T {
        return (current?.key)!
    }
    
    public func next() {
        if let nCurrent = current?.next {
            current = nCurrent
            return
        }
        current = head
    }
    
    public func prev() {
        if let nCurrent = current?.prev {
            current = nCurrent
            return
        }
        current = tail
    }
    
}

public struct MediaInfo {
    public var media: Media
    public var playerItem: AVPlayerItem
    public init(media: Media, item: AVPlayerItem) {
        self.media = media
        self.playerItem = item
    }
}
