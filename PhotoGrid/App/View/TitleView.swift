//
//  TitleView.swift
//  PhotoGrid
//
//  Created by Yevhenii Boryspolets on 30.11.2023.
//

import UIKit

class TitleView: UIView {
    let backgroundImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "Header-BG")
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.boldSystemFont(ofSize: 23)
        view.textColor = .white
        view.text = "New Photos"
        view.textAlignment = .center
        return view
    }()
    
    private  func setupView() {
        addSubview(backgroundImageView)
        addSubview(titleLabel)
        
        backgroundImageView
            .fillSuperview()
        
        titleLabel
            .anchorBottom(backgroundImageView.bottomAnchor, 10)
            .anchorLeading(leadingAnchor, 48)
            .anchorTrailing(trailingAnchor, 48)
    }
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
