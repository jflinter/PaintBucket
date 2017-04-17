//
//  ViewController.swift
//  PaintBucketExample
//
//  Created by Jack Flintermann on 3/14/16.
//  Copyright © 2016 jflinter. All rights reserved.
//

import UIKit
import PaintBucket

class ViewController: UIViewController {
    
    let imageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.orange
        self.view.addSubview(self.imageView)
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.image = UIImage(named: "benchmark")?.pbk_imageByReplacingColorAt(0, 0, withColor: .clear, tolerance: 200, antialias: true)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.imageView.frame = self.view.bounds
    }

}
