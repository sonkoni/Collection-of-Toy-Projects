//
//  ViewController.swift
//  IosSwiftEmpty
//
//  Created by Kiro on 2022/11/16.
//

import UIKit
import BaseKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.systemRed
    }
    
    func hello(_ state:MGREmptyState) {
        print(state)
        
    }


}

