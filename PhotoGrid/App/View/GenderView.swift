//
//  GenderView.swift
//  PhotoGrid
//
//  Created by Yevhenii Boryspolets on 29.11.2023.
//

import UIKit

protocol GenderViewDelegate: AnyObject {
    func didSwitchGender(to gender: GenderView.Gender)
}

class GenderView: UIView {
    open weak var delegate: GenderViewDelegate?
    let contentView = ImageWithLabelView()
    
    enum Gender {
        case male
        case female
        case both
        
        var image: UIImage? {
            switch self {
            case .male: return UIImage(named: "Male")?.withRenderingMode(.alwaysOriginal)
            case .female: return UIImage(named: "Female")?.withRenderingMode(.alwaysOriginal)
            case .both: return UIImage(named: "AnyGender")?.withRenderingMode(.alwaysOriginal)
            }
        }
        
        var title: String {
            switch self {
            case .male: return "Male"
            case .female: return "Female"
            case .both: return "Any"
            }
        }
    }
    
    let switchQueue: [Gender] = [.male, .female, .both]
    var selectedIndex = 0
    var selectedGender: Gender = .male {
        didSet {
            UIView.performWithoutAnimation {
                updateStyle()
            }
        }
    }
    
    private func updateStyle() {
        contentView.titleLabel.text = selectedGender.title
        contentView.imageView.image = selectedGender.image
    }
    
    private func setupView() {
        addSubview(contentView)
        contentView.anchorCenterToSuperview()

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTap))
        tapRecognizer.cancelsTouchesInView = false
        self.addGestureRecognizer(tapRecognizer)
    }
    
    @objc private func onTap(sender: UIView) {
        selectedIndex += 1
        if selectedIndex == switchQueue.count {
            selectedIndex = 0
        }
        
        selectedGender = switchQueue[selectedIndex]
        delegate?.didSwitchGender(to: selectedGender)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        backgroundColor = Colors.bgColor
//        contentView.titleLabel.textColor = .white
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        backgroundColor = .white
//        contentView.titleLabel.textColor = Colors.mainBlue
    }
    
    init() {
        super.init(frame: .zero)
        setupView()
        updateStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ImageWithLabelView: UIView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 13)
        label.textColor = Colors.mainBlue
        return label
    }()
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private func setupView() {
        addSubview(titleLabel)
        addSubview(imageView)
        
        imageView
            .anchorTop(topAnchor, 0)
            .anchorBottom(bottomAnchor, 0)
            .anchorLeading(leadingAnchor, 0)
            .anchorWidth(18)
            .anchorHeight(18)
        
        titleLabel
            .anchorLeading(imageView.trailingAnchor, 8)
            .anchorTrailing(trailingAnchor, 0)
            .anchorCenterYToView(imageView)
    }
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

