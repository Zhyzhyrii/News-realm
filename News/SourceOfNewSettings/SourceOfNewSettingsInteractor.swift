//
//  SourceOfNewSettingsInteractor.swift
//  News
//
//  Created by Игорь on 29.12.2019.
//  Copyright (c) 2019 Igor Zhyzhyrii. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol SourceOfNewSettingsBusinessLogic {
    func displaySourceOfNew(request:SourceOfNewSettings.DisplaySourceOfNew.Request)
    func selectNewSource(request: SourceOfNewSettings.SelectNewSource.Request)
}

protocol SourceOfNewSettingsDataStore {
    var feedsModels: [FeedModel]! { get set }
    var delegate: ProvideFeedDelegate? { get set }
    var numberOfTab: Int! { get set }
}

class SourceOfNewSettingsInteractor: SourceOfNewSettingsBusinessLogic, SourceOfNewSettingsDataStore {
    
    var presenter: SourceOfNewSettingsPresentationLogic?
    var worker: SourceOfNewSettingsWorker?
    var feedsModels: [FeedModel]!
    weak var delegate: ProvideFeedDelegate?
    var numberOfTab: Int!
    
    // MARK: - Display source of new
    
    func displaySourceOfNew(request: SourceOfNewSettings.DisplaySourceOfNew.Request) {
        feedsModels = Feed.allCases.map { (feed) -> FeedModel in
            FeedModel(feedName: feed.newName, feedSource: feed.url, isSelected: isSelected(feed))
        }
        
        let response = SourceOfNewSettings.DisplaySourceOfNew.Response(feeds: feedsModels)
        presenter?.presentSourceOfNew(response: response)
    }
    
    // MARK: - Select new source
    
    func selectNewSource(request: SourceOfNewSettings.SelectNewSource.Request) {
        if let selectedIndex = feedsModels.firstIndex(where: { $0.feedName == request.feed.feedName }) {
            for index in 0..<feedsModels.count {
                feedsModels[index].isSelected = (index == selectedIndex) ? !feedsModels[index].isSelected : false
            }
            self.delegate?.provideFeed(feedsModels[selectedIndex])
        }
        
        let response = SourceOfNewSettings.SelectNewSource.Response(feedsModels: feedsModels)
        presenter?.presentSelectedNewSource(response: response)
    }
    
    // MARK: - Find selected feed for tab
    
    private func isSelected(_ feed: Feed) -> Bool {
        if let feedModel = StorageManager.shared.getSavedFeed(forKey: numberOfTab) {
            return feedModel.feedSource == feed.url
        }
        return false
    }
    
}
