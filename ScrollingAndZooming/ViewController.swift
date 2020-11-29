//
//  ViewController.swift
//  ScrollingAndZooming
//
//  Created by paw on 29.11.2020.
//  Copyright © 2020 paw. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var image: UIScrollableImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        image.setup(with: UIImage(named: "image")!)
    }
        override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if #available(iOS 12.0, *) {
            view.backgroundColor = traitCollection.userInterfaceStyle == .dark ? .black : .white
        } else {
            view.backgroundColor = .white
            
        }
    }

}

