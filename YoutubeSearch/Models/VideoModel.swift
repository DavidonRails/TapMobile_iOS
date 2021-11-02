//
//  VideoModel.swift
//  YoutubeSearch
//
//  Created by Admin on 2021/11/2.
//

import Foundation
class VideoModel : NSObject {
    
    var id = ""
    var title = ""
    var thumbURL = ""
    var length = ""
    var views = ""
    override init() {
        super.init()
    }
    
    init(id: String, title: String, thumbURL: String, length: String, views: String) {
        self.id = id
        self.title = title
        self.thumbURL = thumbURL
        self.length = length
        self.views = views
    }
}
