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
    func displaySomething(viewModel: Settings.SelectTab.ViewModel)
}

class SettingsViewController: UITableViewController, SettingsDisplayLogic {
    
    // MARK: - IBOutlets
    
    @IBOutlet var tabsSettingsLabel: [UILabel]!
    @IBOutlet var intervalLabel: UILabel!
    
    var interactor: SettingsBusinessLogic?
    var router: (NSObjectProtocol & SettingsRoutingLogic & SettingsDataPassing)?
    
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
        
        SettingsConfigurator.shared.configure(with: self)
        
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
    
    // MARK: - Select tab`s settings
    
    func selectSettingsForSpecificTab(indexOfTab: Int) {
        let request = Settings.SelectTab.Request(numberOfTab: indexOfTab)
        interactor?.selectTab(request: request)
    }
    
    func displaySomething(viewModel: Settings.SelectTab.ViewModel) {
        //nameTextField.text = viewModel.name
    }
    
}

extension SettingsViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectSettingsForSpecificTab(indexOfTab: indexPath.row)
        performSegue(withIdentifier: "SourceOfNewSettings", sender: nil)
    }
    
}
