//
//  HomeViewModel.swift
//  Chat App
//
//  Created by Abhishek on 05/07/24.
//

import Foundation
protocol HomeProtocol {
    var router: RouterProtocol { get }
}

class HomeViewModel: HomeProtocol {
    
    var router: RouterProtocol
    
    init(router: RouterProtocol) {
        self.router = router
    }
}
