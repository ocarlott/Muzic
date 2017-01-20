//
//  SearchViewController.swift
//  Muzic
//
//  Created by Michael Ngo on 1/17/17.
//  Copyright © 2017 MIV Solution. All rights reserved.
//

import UIKit

class GenericSearchVC: UIViewController {
    
    let inputBox: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.placeholder = "Search"
        tf.textAlignment = .center
        return tf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    let background: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.3)
        return view
    }()
    
    let bgImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "bg"))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    func setupViews() {
        view.backgroundColor = .white
        UINavigationBar.appearance().barTintColor = .white
        UINavigationBar.appearance().tintColor = .white
        navigationItem.title = "Search"
        view.addSubview(bgImage)
        view.addSubview(background)
        view.addSubview(inputBox)
        view.addConstraintsWithFormatString(format: "V:|-20-[v0]|", views: bgImage)
        view.addConstraintsWithFormatString(format: "V:|-20-[v0]|", views: background)
        view.addConstraintsWithFormatString(format: "H:|[v0]|", views: bgImage)
        view.addConstraintsWithFormatString(format: "H:|[v0]|", views: background)
        view.addConstraintsWithFormatString(format: "V:|-30-[v0(30)]", views: inputBox)
        view.addConstraintsWithFormatString(format: "H:|-5-[v0]-5-|", views: inputBox)
    }
}