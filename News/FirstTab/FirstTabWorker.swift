//
//  FirstTabWorker.swift
//  News
//
//  Created by Игорь on 19.12.2019.
//  Copyright (c) 2019 Igor Zhyzhyrii. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import RealmSwift

class FirstTabWorker: Parser {
    
    func saveNewsToDataBase(news: [New]) {
        
        RealmManager.addObjects(objects: news)
        
    }
    
    func getNewsFromDataBase(feedSource: String) -> [New]? {
        
        return RealmNewManager.getNewsFromDataBase(feedSource: feedSource)
        
    }
    
    // MARK: - Get selected FeedModel
    
    func getSelectedFeedModel(indexOfTab: Int) -> FeedModel? {
        
        guard let feedsModels = UserDefaultsStorageManager.shared.getSavedFeeds(forKey: indexOfTab) else { return nil } //TODO something went wrong alert (not select source for tab)
        guard let feedModel = feedsModels.first(where: { (feedModel) -> Bool in
            feedModel.isSelected
        }) else { return nil } //TODO something went wrong alert (not select source for tab)
        
        return feedModel
        
    }
    
    // MARK: - Get news from DB (if present) or from network
    
    func getNewsFromDBOrNetworkFor(indexOfTab: Int) -> [New]? {
        guard let feedModel = getSelectedFeedModel(indexOfTab: indexOfTab) else { return nil }
        
        if let news = getNewsFromDataBase(feedSource: feedModel.feedSource) {
            return news
        } else {
            guard let news = getNewsFromParser(indexOfTab: indexOfTab) else { return nil }
            saveNewsToDataBase(news: news)
            return news
        }
    }
    
    // MARK: Get saved parser
    
    func getNewsFromParser(indexOfTab: Int) -> [New]? { //TODO do not need this func because we get getNews func ???
        
        guard let feedModel = getSelectedFeedModel(indexOfTab: indexOfTab) else { return nil }
        
        guard let parser = Feed.init(rawValue: feedModel.feedSource)?.parser else { return nil } //TODO something went wrong alert
        
        parser.delegate = self
        parser.startParsingWithContentsOfURL()
        
        return parser.entities.map { (new) -> New in
            new.sourceOfNew = feedModel.feedSource
            return new
        }.sorted { (firstNew, secondNew) -> Bool in
            guard let firstDate = firstNew.pubDate, let secondDate = secondNew.pubDate else { return false }
            return firstDate > secondDate
        }
        
    }
    
    // MARK: - Update news in DB
    
    func updateNewsInDBFor(indexOfTab: Int) {
        var refreshedNews: [New]!
        
        guard let feedModel = getSelectedFeedModel(indexOfTab: indexOfTab) else { return }
        
        guard let newsFromNetwork = getNewsFromParser(indexOfTab: indexOfTab) else { return }
        
        if let newsFromDB = getNewsFromDataBase(feedSource: feedModel.feedSource) {
            var amountOfDifferentNews = 0
            
            for new in newsFromNetwork {
                if new.title != newsFromDB[0].title {
                    amountOfDifferentNews += 1
                } else {
                    break
                }
            }
            refreshedNews = Array(newsFromNetwork.prefix(amountOfDifferentNews))
            saveNewsToDataBase(news: refreshedNews)
        }
    }
    
    // MARK: - Parser delegate method
    
    func parsingWasFinished() {
        print("Parsing was finished") //TODO ??
    }
    
}
