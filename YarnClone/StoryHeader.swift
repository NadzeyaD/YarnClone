//
//  StoryHeader.swift
//  YarnClone
//
//  Created by Nadezhda Demidovich on 9/3/17.
//  Copyright © 2017 Nadezhda Demidovich. All rights reserved.
//


import ObjectMapper

class StoryHeader: Mappable, PictureDownloadable {
    
    //MARK : Properties
    var name : String
    var authorName : String
    var shortDescription: String
    var coverImageUrl: String
    var dateString: String
    var date: Date? {
        get{
            return dateString.toDate(dateFormat: mainDateFormat)
        }
    }
    var contentUrl : String
    var contentFileName : String {
        get {
            return (contentUrl as NSString).lastPathComponent
        }
    }
    var progress : Float = 0
    
    //MARK: PictureDownloadable
    var downloadState : DownloadState = .new
    var image : UIImage?
    var imageUrl : String {
        get {
            return coverImageUrl
        }
    }
    
    //MARK: Inits
    required init?(map: Map){
        self.name = ""
        self.authorName = ""
        self.shortDescription = ""
        self.coverImageUrl = ""
        self.dateString = ""
        self.contentUrl = ""
    }
    
    //MARK : Functions
    func mapping(map: Map) {
        name <- map["storyName"]
        authorName <- map["storyAuthorName"]
        shortDescription <- map["shortDescription"]
        coverImageUrl <- map["coverImageUrl"]
        dateString <- map["date"]
        contentUrl <- map["url"]
    }
}
