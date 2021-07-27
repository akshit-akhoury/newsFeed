//
//  newsModel.swift
//  News Feed
//
//  Created by Akshit Akhoury on 27/07/21.
//

import Foundation

struct enclosure:Codable{
    let link: String
}

struct newsItems:Codable {
    private enum CodingKeys : String, CodingKey {
        case summary = "description"
        case thumbNailURL = "thumbnail"
        case date = "pubDate"
        case title,enclosure
    }
    
    let title: String?
    let date: Date?
    let thumbNailURL: String?
    let summary: String?
    let enclosure: enclosure
}

struct newsFeed: Codable {
    let items : [newsItems]?
}

extension newsFeed {
    init?() {
       return nil
    }
}
