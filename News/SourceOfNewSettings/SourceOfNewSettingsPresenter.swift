//
//  SourceOfNewSettingsPresenter.swift
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

protocol SourceOfNewSettingsPresentationLogic {
    func presentSourceOfNew(response: SourceOfNewSettings.DisplaySourceOfNew.Response)
    func presentSelectedNewSource(response: SourceOfNewSettings.SelectNewSource.Response)
}

class SourceOfNewSettingsPresenter: SourceOfNewSettingsPresentationLogic {
    
    weak var viewController: SourceOfNewSettingsDisplayLogic?

    
    //MARK: - Present source of new
    
    func presentSourceOfNew(response: SourceOfNewSettings.DisplaySourceOfNew.Response) {
        let viewModel = SourceOfNewSettings.DisplaySourceOfNew.ViewModel(feedsModels: response.feeds)
        viewController?.displaySourcesOfNews(viewModel: viewModel)
    }
    
    //MARK: - Select source of new
    
    func presentSelectedNewSource(response: SourceOfNewSettings.SelectNewSource.Response) {
        let viewModel = SourceOfNewSettings.SelectNewSource.ViewModel(feedsModels: response.feedsModels)
        viewController?.displaySelectedSourceOfNew(viewModel: viewModel)
    }
}
