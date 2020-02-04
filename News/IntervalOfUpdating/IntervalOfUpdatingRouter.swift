//
//  IntervalOfUpdatingRouter.swift
//  News
//
//  Created by Игорь on 31.01.2020.
//  Copyright (c) 2020 Igor Zhyzhyrii. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol IntervalOfUpdatingRoutingLogic {
    //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol IntervalOfUpdatingDataPassing {
    var dataStore: IntervalOfUpdatingDataStore? { get }
}

class IntervalOfUpdatingRouter: NSObject, IntervalOfUpdatingRoutingLogic, IntervalOfUpdatingDataPassing {
    
    weak var viewController: IntervalOfUpdatingViewController?
    var dataStore: IntervalOfUpdatingDataStore?
    
    // MARK: Routing
    
    //func routeToSomewhere(segue: UIStoryboardSegue?) {
    //  if let segue = segue {
    //    let destinationVC = segue.destination as! SomewhereViewController
    //    var destinationDS = destinationVC.router!.dataStore!
    //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
    //  } else {
    //    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    //    let destinationVC = storyboard.instantiateViewController(withIdentifier: "SomewhereViewController") as! SomewhereViewController
    //    var destinationDS = destinationVC.router!.dataStore!
    //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
    //    navigateToSomewhere(source: viewController!, destination: destinationVC)
    //  }
    //}
    
    // MARK: Navigation
    
    //func navigateToSomewhere(source: IntervalOfUpdatingViewController, destination: SomewhereViewController) {
    //  source.show(destination, sender: nil)
    //}
    
    // MARK: Passing data
    
    //func passDataToSomewhere(source: IntervalOfUpdatingDataStore, destination: inout SomewhereDataStore) {
    //  destination.name = source.name
    //}
}