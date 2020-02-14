//
//  SettingsViewController.swift
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

protocol SettingsDisplayLogic: class {
    func displaySwitcherValue(viewModel: Settings.GetSwitcherValue.ViewModel)
}

class SettingsViewController: UITableViewController, SettingsDisplayLogic {
    
    // MARK: - IBOutlets
    
    //    @IBOutlet var switcherIntervalOfUpdating: UISwitch!
    
    var interactor: SettingsBusinessLogic?
    var router: (NSObjectProtocol & SettingsRoutingLogic & SettingsDataPassing)?
    
    // MARK: - Private properties
    
    private let titlesForFirstSectionOfTable = ["The first tab",
                                                "The second tab",
                                                "The third tab"]
    
    private let titleForSecondSectionOfTable = "Interval of updating news"
    
    // MARK: Object lifecycle
    
    //    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    //        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    //        setup()
    //    }
    //
    //    required init?(coder aDecoder: NSCoder) {
    //        super.init(coder: aDecoder)
    //        setup()
    //    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "TabSettingCell", bundle: nil), forCellReuseIdentifier: "TabSettingCell")
        tableView.register(UINib(nibName: "IntervalOfUpdatingNewsCell", bundle: nil), forCellReuseIdentifier: "IntervalOfUpdatingNewsCell")
        
        SettingsConfigurator.shared.configure(with: self)
        getSwitcherValue()
        
        configureView()
    }
    
    // MARK: - Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: - Display switcher`s value
    
    func getSwitcherValue() {
        interactor?.getSwitcherValue()
    }
    
    func displaySwitcherValue(viewModel: Settings.GetSwitcherValue.ViewModel) {
        //        switcherIntervalOfUpdating.setOn(viewModel.isOn, animated: false)
    }
    
    // MARK: - Select tab`s settings
    
    func selectSettingsForSpecificTab(indexOfTab: Int) {
        let request = Settings.SelectTab.Request(numberOfTab: indexOfTab)
        interactor?.selectTab(request: request)
    }
    
    func displaySomething(viewModel: Settings.SelectTab.ViewModel) {
        //nameTextField.text = viewModel.name
    }
    
    // MARK: - Private methods
    
    private func configureView() {
        view.backgroundColor                                    = Constants.Colors.backGroundColor
        
        navigationController?.navigationBar.barTintColor        = Constants.Colors.backGroundColor
        navigationController?.navigationBar.topItem?.title      = tabBarController?.tabBar.selectedItem?.title
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.tintColor           = Constants.Colors.navigationTabBarItemColor
    }
    
    // MARK: - @IBActions
    
    @IBAction func switchIntervalOfUpdatingNews(_ sender: UISwitch) {
        let request = Settings.ChangeValueOfSwitchOfIntervalOfUpdating.Request(switchValue: sender.isOn)
        interactor?.changeValueOfSwitchOfIntervalOfUpdating(request: request)
    }
    
}

extension SettingsViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TabSettingCell", for: indexPath) as! TabSettingCell
            
            cell.titleText.text = "\(titlesForFirstSectionOfTable[indexPath.row])"
            
            cell.configure()
            
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "IntervalOfUpdatingNewsCell", for: indexPath) as! IntervalOfUpdatingNewsCell
            
            cell.titleText.text = titleForSecondSectionOfTable
            
            cell.configure()
            
            return cell
        }
        return UITableViewCell()
    }
    
}

extension SettingsViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            selectSettingsForSpecificTab(indexOfTab: indexPath.row)
            performSegue(withIdentifier: "SourceOfNewSettings", sender: nil) // TODO constant
        } else {
            performSegue(withIdentifier: "IntervalOfUpdating", sender: nil) // TODO constant
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.tintColor            = Constants.Colors.backGroundColor
            header.textLabel?.textColor = Constants.Colors.titleTextColor
            header.textLabel?.font      = Constants.Fonts.titleTextFontSize
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let cell                  = cell as! TabSettingCell
            cell.backgroundColor      = Constants.Colors.backGroundColor
            cell.titleText.textColor  = Constants.Colors.mainTextColor
            cell.titleText.font       = Constants.Fonts.settingsOptionsTextFontSize
        } else if indexPath.section == 1 {
            let cell                  = cell as! IntervalOfUpdatingNewsCell
            cell.backgroundColor      = Constants.Colors.backGroundColor
            cell.titleText.textColor  = Constants.Colors.mainTextColor
            cell.titleText.font       = Constants.Fonts.settingsOptionsTextFontSize
        }
    }
    
}
