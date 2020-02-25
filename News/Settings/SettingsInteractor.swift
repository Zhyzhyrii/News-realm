//
//  SettingsInteractor.swift
//  News
//
//  Created by Игорь on 27.12.2019.
//  Copyright (c) 2019 Igor Zhyzhyrii. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol SettingsBusinessLogic {
    func selectTab(request: Settings.SelectTab.Request)
    func changeValueOfSwitchOfIntervalOfUpdating(request: Settings.ChangeValueOfSwitchOfIntervalOfUpdating.Request)
    func getSwitcherValue()
}

protocol SettingsDataStore {
    var numberOfTab: Int! { get }
}

class SettingsInteractor: SettingsBusinessLogic, SettingsDataStore {
    
    var presenter: SettingsPresentationLogic?
    
    var numberOfTab: Int!
    
    // MARK: Select tab
    
    func selectTab(request: Settings.SelectTab.Request) {
        numberOfTab = request.numberOfTab
    }
    
    // MARK: - on/off switch value
    
    func changeValueOfSwitchOfIntervalOfUpdating(request: Settings.ChangeValueOfSwitchOfIntervalOfUpdating.Request) {
        UserDefaultsStorageManager.shared.saveSwitchValueForIntervalOfUpdating(value: request.switchValue)
    }
    
    // MARK: - Get switcher value
    
    func getSwitcherValue() {
        let isOn = UserDefaultsStorageManager.shared.getSavedSwitchValueForIntervalOfUpdating()
        let response = Settings.GetSwitcherValue.Response(isOn: isOn)
        presenter?.presentSwitcherValue(response: response)
    }
}
