//
//  ControlPanel.swift
//  PhotoGrid
//
//  Created by Yevhenii Boryspolets on 29.11.2023.
//

import UIKit

protocol ControlPanelDelegate: AnyObject {
    func didSwitchGender(to gender: GenderView.Gender)
    func didTapAgeButton()
}

class ControlPanel: UIView {
    open weak var delegate: ControlPanelDelegate?
    
    open func updateAgeLabelColor(isSelected: Bool) {
        ageFilterLabel.textColor = isSelected ? Colors.ageLabelColor : Colors.mainBlue
    }
    
    open func updateAgeLabelText(low: Int, high: Int) {
        ageFilterLabel.text = "\(low)-\(high)"
    }
    
    let genderView = GenderView()
    let languageView = LanguageView()
    
    lazy var ageFilterLabel: UILabel = {
        let label = TappableLabel()
        label.text = "21-47"
        label.textAlignment = .center
        label.textColor = Colors.mainBlue
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.isUserInteractionEnabled = true
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapOnAgeLabel))
        tapRecognizer.cancelsTouchesInView = false
        label.addGestureRecognizer(tapRecognizer)
        
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
    
    @objc private func didTapOnAgeLabel() {
        delegate?.didTapAgeButton()
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
