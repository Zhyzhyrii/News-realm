//
//  FirstTabInteractor.swift
//  News
//
//  Created by Игорь on 19.12.2019.
//  Copyright (c) 2019 Igor Zhyzhyrii. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol FirstTabBusinessLogic {
    func getNewsFromDBOrNetworkFor(request: FirstTab.GetNewsFromDBOrNetwork.Request)
    func getNewsByRefreshing(request: FirstTab.RefreshNews.Request)
    func getNewsByTimer(request: FirstTab.GetNewsByTimer.Request)
    func getNavigationBar(request: FirstTab.DisplayNavigatioBar.Request)
}

protocol FirstTabDataStore {
    var news: [New]? { get }
}

class FirstTabInteractor: FirstTabBusinessLogic, FirstTabDataStore {
    
    var presenter: FirstTabPresentationLogic?
    var worker = FirstTabWorker()
    
    var news: [New]?
    
    private var timer: Timer?
    
    // MARK: Get news from BD. If news are missing in DB - fetch news from network
    
    func getNewsFromDBOrNetworkFor(request: FirstTab.GetNewsFromDBOrNetwork.Request) {
        worker.getNewsFromDBOrNetworkFor(indexOfTab: request.indexOfTab) { [weak self] (news, getNewsError) in
            guard let self = self else { return }
            
            if let error = getNewsError, error == .noSourceIsSelected {
                self.news = nil
            }
            if let news = news {
                self.news = news
            }
        }
        let response = FirstTab.GetNewsFromDBOrNetwork.Response(news: self.news)
        presenter?.presentNews(response: response)
    }
    
    // MARK: - Get news by refreshing
    
    func getNewsByRefreshing(request: FirstTab.RefreshNews.Request) {
        guard let news = getNewsByRefreshing(indexOfTab: request.indexOfTab) else { return }
       
        let response = FirstTab.RefreshNews.Response(news: news)
        presenter?.presentNewsByRefreshing(response: response)
    }
    
    // MARK: - Get news by timer
    
    func getNewsByTimer(request: FirstTab.GetNewsByTimer.Request) {
        if UserDefaultsStorageManager.shared.getSavedSwitchValueForIntervalOfUpdating() {
            startTimer(indexOfTab: request.indexOfTab)
        } else {
            stopTimer()
        }
    }
    
    // MARK: - Get navigation bar
    
    func getNavigationBar(request: FirstTab.DisplayNavigatioBar.Request) {
        var title: String?
        if let selectedFeedModel = worker.getSelectedFeedModel(indexOfTab: request.indexOfTab) {
            title = selectedFeedModel.feedName
        }
        let reponse = FirstTab.DisplayNavigatioBar.Response(title: title)
        presenter?.presentNavigationBar(response: reponse)
    }
    
    private func startTimer(indexOfTab: Int) {
        guard timer == nil else { return }
        guard let timeInterval = UserDefaultsStorageManager.shared.getSavedIntervalOfUpdatingInSeconds() else { return }
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(timeInterval), target: self, selector: #selector(getNewsByTimer(timer:)), userInfo: indexOfTab, repeats: true)
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - Get news by timer
    
    @objc private func getNewsByTimer(timer: Timer) {
        if let indexOfTab = timer.userInfo as? Int {
            print(indexOfTab)
            guard let news = getNewsByRefreshing(indexOfTab: indexOfTab) else { return }
            
            let response = FirstTab.GetNewsByTimer.Response(news: news)
            presenter?.presentNewsByTimer(response: response)
        }
    }
    
    // MARK: - Get news from network and update DB
    
    private func getNewsByRefreshing(indexOfTab: Int) -> [New]? {
        worker.updateNewsInDBFor(indexOfTab: indexOfTab)
        worker.getNewsFromDBOrNetworkFor(indexOfTab: indexOfTab) { [weak self ] (news, getNewsError) in
            guard let self = self else { return }
            guard let news = news else { return }
            self.news = news
        }
        return news
     }
    
}
