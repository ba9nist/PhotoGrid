//
//  PhotoGridViewController.swift
//  PhotoGrid
//
//  Created by Yevhenii Boryspolets on 29.11.2023.
//

import UIKit
import DifferenceKit

class PhotoGridViewController: UIViewController {
    let controlsView = ControlPanel()
    var columnCount = 3 {
        didSet {
            collectionLayout.columnsCount = columnCount
            collectionLayout.invalidateLayout()
        }
    }
    
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
    
    var lowAge: Int = 21
    var highAge: Int = 47
    var gender: GenderView.Gender = .male
    
    var extraOffset: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 70 : 0
    var extraMargin: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 16 : 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dataSource = DataSource()
        generatedData = dataSource.buildData()
        collectionData = generatedData.filter{ $0.gender == .male }
        
        view.backgroundColor = Colors.bgColor
        configureNavigation()
        setupView()
        
        controlsView.delegate = self
        updateCollection()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateLayout(for: view.frame.size)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        updateLayout(for: size)
    }
    
    private func updateLayout(for size: CGSize) {
        columnCount = size.width > 400 ? 5 : 3
        
        controlsView.updateLayout()
    }
    
    private func setupView() {
        view.addSubview(controlsView)
        view.addSubview(collectionView)
        
        controlsView
            .anchorTop(view.topAnchor, extraOffset)
            .anchorLeading(view.leadingAnchor, extraOffset)
            .anchorTrailing(view.trailingAnchor, extraOffset)
        
        collectionView
            .anchorTop(controlsView.bottomAnchor, extraMargin)
            .anchorBottom(view.safeAreaLayoutGuide.bottomAnchor, 0)
            .anchorLeading(view.leadingAnchor, extraOffset)
            .anchorTrailing(view.trailingAnchor, extraOffset)
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
        
        switch gender {
        case .male: newData = generatedData.filter{ $0.gender == .male }
        case .female: newData = generatedData.filter{ $0.gender == .female }
        case .both: newData = generatedData
        }
        
        newData = newData.filter{ $0.age >= lowAge && $0.age <= highAge }
        
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
        let width = (collectionView.frame.width - 3 * (num - 1)) / num  // divide screen and substract spacing
        
        let size = CGSize.init(width: width, height: width*ratio)
        
        return size
    }
}

extension PhotoGridViewController: ControlPanelDelegate {
    func didUpdateAgeFilter(low: Int, high: Int) {
        self.lowAge = low
        self.highAge = high
        updateCollection()
    }
   
    func didSwitchGender(to gender: GenderView.Gender) {
        self.gender = gender
        updateCollection()
    }
}
