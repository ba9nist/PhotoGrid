//
//  PhotoGridViewController.swift
//  PhotoGrid
//
//  Created by Yevhenii Boryspolets on 29.11.2023.
//

import UIKit
import DifferenceKit

class PhotoGridViewController: UIViewController {
    let titleView = TitleView()
    let controlsView = ControlPanel()
    var columnCount = 3 {
        didSet {
            collectionLayout.columnsCount = columnCount
            collectionLayout.invalidateLayout()
        }
    }
    
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
    
    private lazy var collectionLayout: PinterestLayout = {
        var layout = PinterestLayout()
        layout.columnsCount = columnCount
        layout.delegate = self
        layout.cellsPadding = PinterestLayout.Padding(horizontal: 3, vertical: 3)
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = Colors.bgColor
        collectionView.register(PhotoGridCollectionViewCell.self, forCellWithReuseIdentifier: "PhotoGridCollectionViewCell")
        return collectionView
    }()
    
    var collectionData = [PersonCard]()
    var generatedData: [PersonCard] = []
    
    var ageSliderHeightConstraint: NSLayoutConstraint?
    var ageSliderTopContraint: NSLayoutConstraint?
    var shouldShowAgeSlider = false
    
    lazy var debounceTimer = CustomTimer(time: 0.3, repeats: false, target: self, action: #selector(handleTimerEvent))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dataSource = DataSource()
        generatedData = dataSource.buildData()
        collectionData = generatedData.filter{ $0.gender == .male }
        
        view.backgroundColor = .white
        configureNavigation()
        setupView()
        
        controlsView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateNumberOfColumns(for: view.frame.size)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        updateNumberOfColumns(for: size)
    }
    
    private func updateNumberOfColumns(for size: CGSize) {
        columnCount = size.width > 400 ? 5 : 3
    }
    
    @objc private func handleTimerEvent() {
        let lowValue = Int(ageControl.lowerValue)
        let highValue = Int(ageControl.upperValue)
        
        controlsView.updateAgeLabelText(low: lowValue, high: highValue)
        updateCollection()
    }
    
    @objc private func onSliderValueChanged(_ slider: RangeSlider) {
        debounceTimer.reset()
    }
    
    private func setupView() {
        view.addSubview(titleView)
        view.addSubview(controlsView)
        view.addSubview(collectionView)
        view.addSubview(ageControl)
        
        titleView
            .anchorTop(view.topAnchor, 0)
            .anchorLeading(view.leadingAnchor, 0)
            .anchorTrailing(view.trailingAnchor, 0)
            .anchorHeight(calculateHeightOfNavbar())
        
        controlsView
            .anchorTop(titleView.bottomAnchor, 16)
            .anchorLeading(view.leadingAnchor, 0)
            .anchorTrailing(view.trailingAnchor, 0)
            .anchorHeight(32)
        
        
        ageControl
            .anchorLeading(view.leadingAnchor, 16)
            .anchorTrailing(view.trailingAnchor, 16)
            
        ageSliderTopContraint = ageControl._anchorTop(controlsView.bottomAnchor, 0)
        ageSliderHeightConstraint = ageControl._anchorHeight(0)
        
        collectionView
            .anchorTop(ageControl.bottomAnchor, 16)
            .anchorBottom(view.safeAreaLayoutGuide.bottomAnchor, 0)
            .anchorLeading(view.leadingAnchor, 0)
            .anchorTrailing(view.trailingAnchor, 0)
    }
    
    private func calculateHeightOfNavbar() -> CGFloat {
        let topInset = UIApplication.shared.windows.first?.safeAreaInsets.top ?? .zero
        
        return topInset + 48
    }
    
    private func configureNavigation() {
        let bgImage = UIImage(named: "Header-BG")
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundImage = bgImage
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 23)
        ]
        
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
        
        navigationItem.title = "New Photos"
    }
    
    private func updateCollection() {
        var newData: [PersonCard]
        let gender = controlsView.genderView.selectedGender
        
        switch gender {
        case .male: newData = generatedData.filter{ $0.gender == .male }
        case .female: newData = generatedData.filter{ $0.gender == .female }
        case .both: newData = generatedData
        }
        
        let lowValue = Int(ageControl.lowerValue)
        let highValue = Int(ageControl.upperValue)
        newData = newData.filter{ $0.age >= lowValue && $0.age <= highValue }
        
        let diff = StagedChangeset(source: collectionData, target: newData)

        collectionView.reload(using: diff) { data in
            collectionData = data
        }
    }
}

extension PhotoGridViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoGridCollectionViewCell", for: indexPath) as? PhotoGridCollectionViewCell {
            let model = collectionData[indexPath.item]
            cell.configure(image: UIImage(named: model.image))
            return cell
        }
        
        return UICollectionViewCell()
    }
}

extension PhotoGridViewController: PinterestLayoutDelegate {
    func cellSize(indexPath: IndexPath) -> CGSize {
        let model = collectionData[indexPath.item]
        let image = UIImage(named: model.image)!
        
        let ratio = image.size.height / image.size.width
        
        let num = CGFloat(columnCount)
        let width = (view.frame.width - 3 * (num - 1)) / num  // divide screen and substract spacing
        
        let size = CGSize.init(width: width, height: width*ratio)
        
        return size
    }
}

extension PhotoGridViewController: ControlPanelDelegate {
    func didTapAgeButton() {
        shouldShowAgeSlider = !shouldShowAgeSlider
        
        ageSliderHeightConstraint?.constant = shouldShowAgeSlider ? 32 : 0
        ageSliderTopContraint?.constant = shouldShowAgeSlider ? 16 : 0
        ageControl.isHidden = true
        
        controlsView.updateAgeLabelColor(isSelected: shouldShowAgeSlider)
        
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.ageControl.isHidden = !self.shouldShowAgeSlider
        }

    }
    
    func didSwitchGender(to gender: GenderView.Gender) {
        updateCollection()
    }
}
