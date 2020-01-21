//
//  SourceOfNewSettingsModels.swift
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

enum SourceOfNewSettings {
    
    // MARK: Use cases
    
    enum SelectNewSource {
        struct Request {
            let feed: FeedModel
        }
        
        struct Response {
            let feedsModels: [FeedModel]
        }
        
        struct ViewModel {
            let feedsModels: [FeedModel]
        }
    }
    
    enum DisplaySourceOfNew {
        struct Request {
        }
        
        struct Response {
            let feeds: [FeedModel]
        }
        
        struct ViewModel {
            let feedsModels: [FeedModel]
        }
    }
    
    enum DisplayNavigationTitle {
        struct Request {
        }
        
        struct Response {
            let numberOfTab: Int
        }
        
        struct ViewModel {
            let title: String
        }
    }
    
    enum SaveFeedSettings {
        struct Request {
        }
        
        struct Response {
            let feeds: [FeedModel]
            let numberOfTab: Int
            let indexPathfOfEditedRow: IndexPath?
        }
        
        struct ViewModel {
            let feedName: String
            let numberOfTab: Int
            let indexPathOfRow: IndexPath?
        }
    }
    
    enum UpdateTitleOfTheNew {
        struct Request {
            let feedName: String
            let indexPathOfRow: IndexPath
        }
        
        struct Response {
            let feeds: [FeedModel]
            let numberOfTab: Int
            let indexPathfOfEditedRow: IndexPath?
        }
        
        struct ViewModel {
            let feeds: [FeedModel]
            let numberOfTab: Int
            let indexPathOfRow: IndexPath?
        }
    }
    
    enum DisplayTabBarItemTitle {
        struct Request {
        }
        
        struct Response {
            let numberOfTab: Int
            let title: String
        }
        
        struct ViewModel {
            let numberOfTab: Int
            let title: String
        }
    }
    
}
