//
//  ViewController.swift
//  SplashAd
//
//  Created by EricSue on 16/05/2018.
//  Copyright © 2018 EricSue. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let label = UILabel(frame:CGRect(x:10,y:70,width:self.view.frame.size.width-20,height:45))
        label.text = "Home"
        label.textAlignment = .center
        self.view.addSubview(label)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

