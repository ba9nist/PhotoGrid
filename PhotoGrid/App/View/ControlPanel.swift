//
//  ControlPanel.swift
//  PhotoGrid
//
//  Created by Yevhenii Boryspolets on 29.11.2023.
//

import UIKit

protocol ControlPanelDelegate: AnyObject {
    func didSwitchGender(to gender: GenderView.Gender)
}

class ControlPanel: UIView {
    open weak var delegate: ControlPanelDelegate?
    
    let genderView = GenderView()
    let languageView = LanguageView()
    
    let ageFilterLabel: UILabel = {
        let label = UILabel()
        label.text = "21-47"
        label.textAlignment = .center
        label.textColor = Colors.mainBlue
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    
    let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .fill
        return view
    }()
    
    private  func setupView() {
        let views = [genderView, buildLine(), ageFilterLabel, buildLine(), languageView]
        
        views.forEach{ stackView.addArrangedSubview($0) }
        ageFilterLabel.widthAnchor.constraint(equalTo: genderView.widthAnchor).isActive = true
        languageView.widthAnchor.constraint(equalTo: ageFilterLabel.widthAnchor).isActive = true
        
        addSubview(stackView)
        stackView.fillSuperview()
        
        genderView.delegate = self
    }
    
    private func buildLine() -> UIView {
        let view = UIView()
        view.backgroundColor = Colors.separator
        view.anchorWidth(1)
        return view
    }
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ControlPanel: GenderViewDelegate {
    func didSwitchGender(to gender: GenderView.Gender) {
        delegate?.didSwitchGender(to: gender)
    }
}
