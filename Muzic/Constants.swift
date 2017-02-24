//
//  Constants.swift
//  Muzic
//
//  Created by Michael Ngo on 1/17/17.
//  Copyright © 2017 MIV Solution. All rights reserved.
//

import Foundation

let SUGGEST_API_URL = "http://suggestqueries.google.com/complete/search?client=youtube&ds=yt&q="
let API_KEY = "AIzaSyChrbG-yMd56aYXFIWb4MOJ0xoq-tUjdzM"
let SEARCH_API_URL = "https://www.googleapis.com/youtube/v3/search?part=snippet&key=" + API_KEY + "&q="
let CONTENT_DETAIL_API_URL = "https://www.googleapis.com/youtube/v3/videos?part=contentDetails&key=" + API_KEY + "&id="
let DOWNLOAD_VIDEO_API_URL = "http://michaelngo.ml/api/youtube?video=1&v="
let DOWNLOAD_AUDIO_API_URL = "http://michaelngo.ml/api/youtube?video=0&v="
let DOCUMENT_DIR_URL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.appdev")!
let PLAYER_IMAGE_DIR_URL = DOCUMENT_DIR_URL.appendingPathComponent("image", isDirectory: true)

