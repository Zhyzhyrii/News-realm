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
    func displayNews(viewModel: FirstTab.GetNewsFromDBOrNetwork.ViewModel)
    func displayNewsByRefreshing(viewModel: FirstTab.RefreshNews.ViewModel)
    func displayNewsByTimer(viewModel: FirstTab.GetNewsByTimer.ViewModel)
}

class FirstTabViewController: UITableViewController, FirstTabDisplayLogic {
    
    //@IBOutlet private var nameTextField: UITextField!
    
    @IBOutlet var navigationBar: UINavigationItem!
    
    // MARK: - Public properties
    
    var interactor: FirstTabBusinessLogic?
    var router: (NSObjectProtocol & FirstTabRoutingLogic & FirstTabDataPassing)?
    
    var parser: GenericNewsParser!
    
    // MARK: - Private properties
    
    private var news: [DisplayedNew]!
    
    //    private var feedsModels: [FeedModel]!
    //    private lazy var selectedIndexOfTab = tabBarController?.selectedIndex
    private var selectedIndex = -1
    private var tabBar: UITabBar!
    private var indexOfTab: Int!
    
//    private var timer: Timer!
    
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
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FirstTabConfigurator.shared.configure(with: self)
        
        tableView.register(UINib(nibName: "NewCell", bundle: nil), forCellReuseIdentifier: "NewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let tabBar = tabBarController?.tabBar else { return }
        guard let selectedBarItem = tabBar.selectedItem else { return }
        indexOfTab = tabBar.items?.firstIndex(of: (selectedBarItem))
        
        navigationBar.title = tabBar.selectedItem?.title
        
        getNews(indexOfTab: indexOfTab)
        getNewsByTimer(indexOfTab: indexOfTab)
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
    
    // MARK: Display news
    
    func displayNews(viewModel: FirstTab.GetNewsFromDBOrNetwork.ViewModel) {
        displayNews(news: viewModel.news)
    }
    
    //MARK: - Get news
    
    func getNews(indexOfTab: Int)  {
        let request = FirstTab.GetNewsFromDBOrNetwork.Request(indexOfTab: indexOfTab)
        interactor?.getNewsFromDBOrNetworkFor(request: request)
    }
    
    // MARK: - Display news by refreshing
    
    func displayNewsByRefreshing(viewModel: FirstTab.RefreshNews.ViewModel) {
        displayNews(news: viewModel.news)
    }
    
    //MARK: - Display news by timer
    
    func displayNewsByTimer(viewModel: FirstTab.GetNewsByTimer.ViewModel) {
        displayNews(news: viewModel.news)
    }
    
    // MARK: - Get news via timer
    
    func getNewsByTimer(indexOfTab: Int) {
        let request = FirstTab.GetNewsByTimer.Request(indexOfTab: indexOfTab)
        interactor?.getNewsByTimer(request: request)
    }
    
    // MARK: - Private methods
    
    private func displayNews(news: [DisplayedNew]) {
        self.news = news
        tableView.reloadData()
    }
    
    private func getNewsByRefreshing(indexOfTab: Int) {
        let request = FirstTab.RefreshNews.Request(indexOfTab: indexOfTab)
        interactor?.getNewsByRefreshing(request: request)
    }
    
//    @objc private func getNewsByTimer(timer: Timer) {
//        if let indexOfTab = timer.userInfo as? Int {
//            print(indexOfTab)
//            getNewsByRefreshing(indexOfTab: indexOfTab)
//        }
//    }
    
    // MARK: - IBActions
    
    @IBAction func refreshButtonPressed(_ sender: UIBarButtonItem) {
        getNewsByRefreshing(indexOfTab: indexOfTab)
    }
    
}

extension FirstTabViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let news = news else { return 0 }
        return news.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewCell", for: indexPath) as! NewCell
        
        guard let news = news else { return UITableViewCell() }
        
        cell.configure(with: news[indexPath.row])
        if selectedIndex == indexPath.row {
            cell.newTextLabel.isHidden = false
        }
        cell.selectionStyle = .none
        
        return cell
    }
    
}

extension FirstTabViewController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == selectedIndex {
            return 120
        }
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! NewCell
        if indexPath.row == selectedIndex {
            selectedIndex = -1
            cell.newTextLabel?.isHidden = true
        }else{
            selectedIndex = indexPath.row
            cell.newTextLabel?.isHidden = false
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {

        guard let cell = tableView.cellForRow(at: indexPath) as? NewCell else { return }
        cell.newTextLabel?.isHidden = true

    }
    
}
