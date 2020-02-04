//
//  IntervalOfUpdatingViewController.swift
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

protocol IntervalOfUpdatingDisplayLogic: class {
//    func displaySomething(viewModel: IntervalOfUpdating.Something.ViewModel)
}

class IntervalOfUpdatingViewController: UIViewController, IntervalOfUpdatingDisplayLogic {
    
    // MARK: - @IBOutlets
    
    @IBOutlet var timeIntervalPickerView: UIPickerView!
    
    // MARK: - Public properties
    
    var interactor: IntervalOfUpdatingBusinessLogic?
    var router: (NSObjectProtocol & IntervalOfUpdatingRoutingLogic & IntervalOfUpdatingDataPassing)?
    
    // MARK: - Private properties
    
    private var hours = 0
    private var minutes = 0
    private var seconds = 0
    
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
        IntervalOfUpdatingConfigurator.shared.configure(with: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let savedInterval = UserDefaultsStorageManager.shared.getSavedIntervalOfUpdatingInSeconds() {
            let savedTime = TimeHelper.convertSecondsToTime(seconds: savedInterval)
            hours = savedTime.hours
            minutes = savedTime.minutes
            seconds = savedTime.seconds
        }
        timeIntervalPickerView.selectRow(hours, inComponent: 0, animated: true)
        timeIntervalPickerView.selectRow(minutes, inComponent: 1, animated: true)
        timeIntervalPickerView.selectRow(seconds, inComponent: 2, animated: true)
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
    
    // MARK: Do something
    
//    func displaySomething(viewModel: IntervalOfUpdating.Something.ViewModel) {
        //nameTextField.text = viewModel.name
//    }
    
    // MARK: - IBActions
    
    
}

extension IntervalOfUpdatingViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 24
        case 1,2:
            return 60
        default:
            return 0
        }
    }
    
}

extension IntervalOfUpdatingViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "\(row) Hours"
        case 1:
            return "\(row) Minutes"
        case 2:
            return "\(row) Seconds"
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            switch component {
            case 0:
                hours = row
            case 1:
                minutes = row
            case 2:
                seconds = row
            default:
                break
            }
        
        let savedInterval = TimeHelper.convertTimeToSeconds(hours: hours, minutes: minutes, seconds: seconds)
        
        let request = IntervalOfUpdating.SaveIntervalOfUpdating.Request(seconds: savedInterval)
        interactor?.saveIntervalOfUpdating(request: request)
    }
    
}
