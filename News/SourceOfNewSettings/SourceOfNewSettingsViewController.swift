//
//  SourceOfNewSettingsViewController.swift
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

protocol SourceOfNewSettingsDisplayLogic: class {
    func displayNavigationTitle(viewModel: SourceOfNewSettings.DisplayNavigationTitle.ViewModel)
    func displayTabBarItemTitle(viewModel: GetTabBarItemTitleForViewModel & GetNumberOfTab)
    func displaySourcesOfNews(viewModel: GetFeedModels)
    
    func displayTitleOfTheNew(viewModel: SourceOfNewSettings.UpdateTitleOfTheNew.ViewModel)
    func displayAlertTheSameTitle(viewModel: SourceOfNewSettings.UpdateTitleOfTheNew.ViewModel)
}

class SourceOfNewSettingsViewController: UITableViewController, SourceOfNewSettingsDisplayLogic, ChangeValueOfSourceOfNewSwitcher {
    
    // MARK: - @IBOutlets
    
    @IBOutlet var saveButton: UIBarButtonItem!
    
    // MARK: - Public properties
    
    var interactor: SourceOfNewSettingsBusinessLogic?
    var router: (NSObjectProtocol & SourceOfNewSettingsRoutingLogic & SourceOfNewSettingsDataPassing)?
    
    // MARK: - Private properties
    
    private var feedsModels: [FeedModel]!
    
    // MARK: - Object lifecycle
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        SourceOfNewSettingsConfigurator.shared.configure(with: self)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Constants.Colors.backGroundColor
        
        tableView.register(UINib(nibName: Constants.CellIdentifiers.sourceOfNewSettingsCell, bundle: nil), forCellReuseIdentifier: Constants.CellIdentifiers.sourceOfNewSettingsCell)
        
        displayNavigationTitle()
        displaySourceOfNews()
        displayTabBarTitle()
        
    }
    
    // MARK: - Display navigation title
    
    func displayNavigationTitle() {
        interactor?.displayNavigationTitle()
    }
    
    func displayNavigationTitle(viewModel: SourceOfNewSettings.DisplayNavigationTitle.ViewModel) {
        navigationItem.title = viewModel.title
    }
    
    // MARK: - Display source of new
    
    func displaySourceOfNews() {
        interactor?.displaySourceOfNews()
    }
    
    func displaySourcesOfNews(viewModel: GetFeedModels) {
        feedsModels = viewModel.feedsModels
        tableView.reloadData()
        for index in 0..<feedsModels.count {
            guard let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? SourceOfNewSettingsCell else { return }
            let toggleValue = (feedsModels[index].isSelected) ? true : false
            cell.turnSourceOfNew.setOn(toggleValue, animated: true)
        }
    }
    
    // MARK: - Display tab bar`s title
    
    func displayTabBarTitle() {
        interactor?.displayTabBarItemTitle()
    }
    
    func displayTabBarItemTitle(viewModel: GetTabBarItemTitleForViewModel & GetNumberOfTab) {
        let numberOfTab = viewModel.numberOfTab
        tabBarController?.tabBar.items?[numberOfTab].title = viewModel.titleOfBar
    }
    
    // MARK: - Select new`s source
    
    func selectNewSource(indexPath: IndexPath) {
        let request = SourceOfNewSettings.SelectNewSource.Request(feed: feedsModels[indexPath.row])
        interactor?.selectNewSource(request: request)
    }
    
    // MARK: - Display title of the new
    
    func displayTitleOfTheNew(viewModel: SourceOfNewSettings.UpdateTitleOfTheNew.ViewModel) {
        
        if let indexPathOfEditedRow = viewModel.indexPathOfRow {
            guard let editedCell = tableView.cellForRow(at: indexPathOfEditedRow) as? SourceOfNewSettingsCell else { return }
            editedCell.sourceLabel.text = viewModel.feeds[indexPathOfEditedRow.row].feedName
            
            feedsModels = viewModel.feeds
        }
    }
    
    // MARK: - Display alert that another new has the same title
    
    func displayAlertTheSameTitle(viewModel: SourceOfNewSettings.UpdateTitleOfTheNew.ViewModel) {
        UIHelpers.showMessage(withTitle: "The same title", message: "Title for tne new must be unique", viewController: self, buttonTitle: "OK")
    }
    
    // MARK: - Change source of new for the specific tab (ChangeValueOfSourceOfNewSwitcher protocol`s method)
    
    func changeSourceOfNewSwitcherValue(_ sender: UISwitch) {
        guard let cell = sender.superview?.superview as? SourceOfNewSettingsCell else { return }
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        selectNewSource(indexPath: indexPath)
    }
    
    //MARK: - @IBActions
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        interactor?.saveFeedSettings()
    }
    
}

extension SourceOfNewSettingsViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedsModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.sourceOfNewSettingsCell, for: indexPath) as? SourceOfNewSettingsCell else { return UITableViewCell() }
        
        cell.delegate = self
        
        cell.configureCellData(with: feedsModels[indexPath.row])
        cell.configureCellView()
        return cell
    }
}

extension SourceOfNewSettingsViewController {
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let changeTheTitleOfNew = UIContextualAction(style: .normal, title: "Update title") {_,_,complete in
            
            UIHelpers.showAlertWithTextField(withTitle: "Change title",
                                             message: "Provide new title for the new",
                                             viewController: self,
                                             buttonTitle: "OK",
                                             actionHandler: { (newTitle) in
                                                guard let newTitle = newTitle else { return }
                                                let request = SourceOfNewSettings.UpdateTitleOfTheNew.Request(feedName: newTitle, indexPathOfRow: indexPath)
                                                self.interactor?.updateTitleOfTheNew(request: request)
                                                
                                                complete(true)
            }) {
                complete(false)
            }
        }
        
        return UISwipeActionsConfiguration(actions: [changeTheTitleOfNew])
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 78
    }
    
}
