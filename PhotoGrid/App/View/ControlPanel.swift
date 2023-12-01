//
//  ControlPanel.swift
//  PhotoGrid
//
//  Created by Yevhenii Boryspolets on 29.11.2023.
//

import UIKit

protocol ControlPanelDelegate: AnyObject {
    func didSwitchGender(to gender: GenderView.Gender)
    func didUpdateAgeFilter(low: Int, high: Int)
}

class ControlPanel: UIView {
    open weak var delegate: ControlPanelDelegate?
    
    open func updateLayout() {
        titleHeightConstraint?.constant = calculateHeightOfNavbar()
    }
    
    let titleView = TitleView()
    let genderView = GenderView()
    let languageView = LanguageView()
    lazy var ageControl: RangeSlider = {
        let slider = RangeSlider()
        slider.maximumValue = 65
        slider.minimumValue = 18
        slider.lowerValue = 21
        slider.upperValue = 47
        slider.thumbTintColor = Colors.mainBlue
        slider.trackTintColor = Colors.bgColor
        slider.trackHighlightTintColor = Colors.sliderColor
        slider.addTarget(self, action: #selector(onSliderValueChanged), for: .valueChanged)
        slider.clipsToBounds = true
        slider.isHidden = true
        
        return slider
    }()
    
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
    
    var titleHeightConstraint: NSLayoutConstraint?
    var ageSliderHeightConstraint: NSLayoutConstraint?
    var ageSliderTopContraint: NSLayoutConstraint?
    var shouldShowAgeSlider = false
    
    lazy var debounceTimer = CustomTimer(time: 0.3, repeats: false, target: self, action: #selector(handleTimerEvent))
    
    private  func setupView() {
        addSubview(titleView)
        addSubview(ageControl)
        addSubview(stackView)
        
        let views = [genderView, buildLine(), ageFilterLabel, buildLine(), languageView]
        
        views.forEach{ stackView.addArrangedSubview($0) }
        ageFilterLabel.widthAnchor.constraint(equalTo: genderView.widthAnchor).isActive = true
        languageView.widthAnchor.constraint(equalTo: ageFilterLabel.widthAnchor).isActive = true
        
        titleHeightConstraint =
        titleView
            .anchorTop(topAnchor, 0)
            .anchorLeading(leadingAnchor, 0)
            .anchorTrailing(trailingAnchor, 0)
            ._anchorHeight(calculateHeightOfNavbar())
        
        stackView
            .anchorTop(titleView.bottomAnchor, 16)
            .anchorLeading(leadingAnchor, 0)
            .anchorTrailing(trailingAnchor, 0)
            .anchorHeight(32)
        
        ageControl
            .anchorLeading(leadingAnchor, 16)
            .anchorTrailing(trailingAnchor, 16)
            .anchorBottom(bottomAnchor, 16)
            
        ageSliderTopContraint = ageControl._anchorTop(stackView.bottomAnchor, 0)
        ageSliderHeightConstraint = ageControl._anchorHeight(0)
        
        genderView.delegate = self
    }
    
    private func calculateHeightOfNavbar() -> CGFloat {
        let topInset = UIApplication.shared.windows.first?.safeAreaInsets.top ?? .zero
        
        return UIDevice.current.userInterfaceIdiom == .pad ? 44 : (topInset + 48)
    }
    
    
    @objc private func didTapOnAgeLabel() {
        shouldShowAgeSlider = !shouldShowAgeSlider
        
        ageSliderHeightConstraint?.constant = shouldShowAgeSlider ? 32 : 0
        ageSliderTopContraint?.constant = shouldShowAgeSlider ? 16 : 0
        ageControl.isHidden = true
        
        ageFilterLabel.textColor = shouldShowAgeSlider ? Colors.ageLabelColor : Colors.mainBlue
        
        UIView.animate(withDuration: 0.1) {
            self.superview?.layoutIfNeeded()
        } completion: { _ in
            self.ageControl.isHidden = !self.shouldShowAgeSlider
        }
    }
    
    @objc private func handleTimerEvent() {
        let lowValue = Int(ageControl.lowerValue)
        let highValue = Int(ageControl.upperValue)
        
        ageFilterLabel.text = "\(lowValue)-\(highValue)"
        delegate?.didUpdateAgeFilter(low: lowValue, high: highValue)
    }
    
    @objc private func onSliderValueChanged(_ slider: RangeSlider) {
        debounceTimer.reset()
    }
    
    private func buildLine() -> UIView {
        let view = UIView()
        view.backgroundColor = Colors.separator
        view.anchorWidth(1)
        return view
    }
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        clipsToBounds = true
        layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? 4 : 0
        
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
