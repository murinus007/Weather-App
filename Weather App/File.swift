//
//  File.swift
//  Weather App
//
//  Created by Alexey Sergeev on 11.11.2021.
//

import Foundation
import UIKit

class FirstVC: UIViewController {
    var places: [String] = []
    
    override func viewDidLoad() {
        let secondVC = SecondVC()
        secondVC.firstVC = self
        secondVC.present()
    }
}

class MainVC: UIViewController {
    var places: [String] = []
    
    override func viewDidLoad() {
        let secondVC = SecondVC()
        secondVC.mainVC = self
        secondVC.present()
    }
}

class SecondVC: UIViewController {
    var firstVC: FirstVC?
    var mainVC: MainVC?
    
    func present() {
        print("Im presented")
        
        
        firstVC?.places.append("Praha")
        mainVC?.places.append("Praha")
    }
}
