//
//  ViewController.swift
//  ScrollingAndZooming
//
//  Created by paw on 29.11.2020.
//  Copyright © 2020 paw. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var image = ZoomableImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(image)
        // constraints
        image.translatesAutoresizingMaskIntoConstraints = false // disable autolayout constraints so they don't conflict with manual ones
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            image.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            image.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // we need to do this in view did appear to avoid the image displaying incorrectly
        image.setup(with: UIImage(named: "image")!)
    }
}

#Preview {
    ViewController()
}
