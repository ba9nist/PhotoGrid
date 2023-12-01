//
//  LanguageView.swift
//  PhotoGrid
//
//  Created by Yevhenii Boryspolets on 29.11.2023.
//

import UIKit

class LanguageView: UIView {
    let languageView: UIView = {
        let view = ImageWithLabelView()
        view.titleLabel.text = "Azerbaijan"
        view.imageView.image = UIImage(named: "flag")
        return view
    }()
    
    private  func setupView() {
        addSubview(languageView)
        
        languageView.anchorCenterToSuperview()
    }
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
