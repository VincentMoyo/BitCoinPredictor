//
//  NewsTableModel.swift
//  BitCoinPredictor
//
//  Created by Vincent Moyo on 2021/07/15.
//

import Foundation

class Article {
    let title: String
    let subtile: String
    let imageURL: URL?
    
    init(
        newsList: NewsList
    ) {
        self.title = newsList.title
        self.subtile = newsList.subtile
        self.imageURL = newsList.imageURL
    }
}
