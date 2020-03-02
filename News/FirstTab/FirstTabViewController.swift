//
//  FirstTabViewController.swift
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

protocol FirstTabDisplayLogic: class {
    func displayNews(viewModel: GetDisplayedNews)
    func doNotDisplayNewsDueToNetworkProblem(viewModel: FirstTab.GetNewsFromDBOrNetwork.ViewModel)
    func displayNavigationBar(viewModel: FirstTab.DisplayNavigatioBar.ViewModel)
    func hideNavigationBar()
}

class FirstTabViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FirstTabDisplayLogic {
    
    //MARK: - @IBOutlets
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var navigationBar: UINavigationBar!
    
    // MARK: - Public properties
    
    var interactor: FirstTabBusinessLogic?
    var router: (NSObjectProtocol & FirstTabRoutingLogic & FirstTabDataPassing)?
    
    // MARK: - Private properties
    
    private var news: [DisplayedNew]?
    
    private var selectedIndex = -1
    private var tabBar: UITabBar!
    private var indexOfTab: Int!
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FirstTabConfigurator.shared.configure(with: self)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: Constants.CellIdentifiers.newCell, bundle: nil), forCellReuseIdentifier: Constants.CellIdentifiers.newCell)
        
        tabBar = tabBarController?.tabBar
        guard let selectedBarItem = tabBar.selectedItem else { return }
        indexOfTab = tabBar.items?.firstIndex(of: (selectedBarItem))
        
        configureView()
        
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressHappened))
        tableView.addGestureRecognizer(recognizer)
    }
    
    @objc func longPressHappened(sender: UILongPressGestureRecognizer) {
        
        if sender.state == .began {
            let touchPoint = sender.location(in: self.tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                let request = FirstTab.SelectNew.Request(indexOfNew: indexPath.row)
                interactor?.selectNew(request: request)
                performSegue(withIdentifier: Constants.SegueIdentifiers.detailedNew, sender: nil)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getNewsFromDBOrNetwork(indexOfTab: indexOfTab)
        getNewsByTimer(indexOfTab: indexOfTab)
        displayNavigationBar()
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: - Display navigation bar
    
    func displayNavigationBar(viewModel: FirstTab.DisplayNavigatioBar.ViewModel) {
        navigationBar.isHidden = false
        navigationBar.topItem?.title = viewModel.title
    }
    
    // MARK: - Hide navigation bar
    
    func hideNavigationBar() {
        navigationBar.isHidden = true
    }
    
    // MARK: Display news
    
    func displayNews(viewModel: GetDisplayedNews) {
        displayNews(news: viewModel.news)
    }
    
    // MARK: - News are not displayed due to internet problem
    
    func doNotDisplayNewsDueToNetworkProblem(viewModel: FirstTab.GetNewsFromDBOrNetwork.ViewModel) {
        displayNews(news: viewModel.news)
        UIHelpers.showMessage(withTitle: "Network error", message: "News was not received due to network problems", viewController: self, buttonTitle: "OK")
    }
    
    // MARK: - Private methods

    private func getNewsFromDBOrNetwork(indexOfTab: Int)  {
        let request = FirstTab.GetNewsFromDBOrNetwork.Request(indexOfTab: indexOfTab)
        interactor?.getNewsFromDBOrNetworkFor(request: request)
    }
    
    private func getNewsByTimer(indexOfTab: Int) {
        let request = FirstTab.GetNewsByTimer.Request(indexOfTab: indexOfTab)
        interactor?.getNewsByTimer(request: request)
    }
    
    private func displayNavigationBar() {
        let request = FirstTab.DisplayNavigatioBar.Request(indexOfTab: indexOfTab)
        interactor?.getNavigationBarTitle(request: request)
    }
    
    private func displayNews(news: [DisplayedNew]?) {
        self.news = news
        tableView.reloadData()
    }
    
    private func getNewsByRefreshing(indexOfTab: Int) {
        let request = FirstTab.RefreshNews.Request(indexOfTab: indexOfTab)
        interactor?.getNewsByRefreshing(request: request)
    }
    
    private func configureView() {
        view.backgroundColor                                 = Constants.Colors.backGroundColor
        
        tableView.backgroundColor                            = Constants.Colors.backGroundColor
        tableView.separatorStyle                             = .none
        
        tabBar.barTintColor                                  = Constants.Colors.backGroundColor
        
        navigationBar.titleTextAttributes                    = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationBar.topItem?.rightBarButtonItem?.tintColor = Constants.Colors.navigationTabBarItemColor
        navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    // MARK: - @IBActions
    
    @IBAction func refreshButtonPressed(_ sender: UIBarButtonItem) {
        getNewsByRefreshing(indexOfTab: indexOfTab)
    }
    
}

extension FirstTabViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let news = news else { return 0 }
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.newCell, for: indexPath) as! NewCell
        
        guard let news = news else { return UITableViewCell() }
        
        cell.configureCellData(with: news[indexPath.row])
        
        if indexPath.row == selectedIndex {
            cell.newTextLabel.text = news[indexPath.row].descripton
            cell.configureSelectedCellView()
        } else {
            cell.configureNotSelectedCellView()
        }
        
        return cell
    }
    
}

extension FirstTabViewController {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == selectedIndex {
            return 120
        }
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? NewCell else { return }
        
        guard let news = news else { return }
        
        if indexPath.row == selectedIndex {
            cell.newTextLabel.text = news[selectedIndex].title
            cell.configureNotSelectedCellView()
            selectedIndex          = -1
        } else {
            selectedIndex          = indexPath.row
            cell.newTextLabel.text = news[selectedIndex].descripton
            cell.configureSelectedCellView()
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) as? NewCell else { return }
       
        cell.newTextLabel.textColor = Constants.Colors.titleTextColor
        cell.newTextLabel.font      = Constants.Fonts.titleTextFontSize
        
    }
    
}
