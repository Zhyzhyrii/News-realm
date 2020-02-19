//
//  DetailedNewPresenter.swift
//  News
//
//  Created by Игорь on 17.02.2020.
//  Copyright (c) 2020 Igor Zhyzhyrii. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol DetailedNewPresentationLogic {
    func presentSelectedNew(response: DetailedNew.DisplaySelectedNew.Response)
}

class DetailedNewPresenter: DetailedNewPresentationLogic {
    
    weak var viewController: DetailedNewDisplayLogic?
    
    // MARK: Present selected new
    
    func presentSelectedNew(response: DetailedNew.DisplaySelectedNew.Response) {
        let viewModel = DetailedNew.DisplaySelectedNew.ViewModel(new: response.new)
        viewController?.displaySelectedNew(viewModel: viewModel)
    }
}
