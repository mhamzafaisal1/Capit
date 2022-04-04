//
//  MainViewController.swift
//  Capit
//
//  Created by Abdullah on 16/03/2020.
//  Copyright © 2020 Abdullah. All rights reserved.
//

import UIKit
import ChameleonFramework

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set nav bar color to specified type.
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation Controller does not exist.")}
        
        let color = UIColor(hexString: "#b80d57")!
        
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance().self
            
            appearance.backgroundColor = color
            appearance.largeTitleTextAttributes = [
                NSAttributedString.Key.foregroundColor: ContrastColorOf(color, returnFlat: true)]
            
            navBar.standardAppearance = appearance
            navBar.compactAppearance = appearance
            navBar.scrollEdgeAppearance = appearance
            navBar.tintColor = ContrastColorOf(color, returnFlat: true)
            
        } else {
            navBar.barTintColor = color
            navBar.tintColor = ContrastColorOf(color, returnFlat: true)
            navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(color, returnFlat: true)]
        }
    }

}
