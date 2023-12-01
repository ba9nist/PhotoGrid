//
//  CustomTabbarController.swift
//  PhotoGrid
//
//  Created by Yevhenii Boryspolets on 29.11.2023.
//

import UIKit

class CustomTabbarController: UITabBarController {
    let tabbarImageNames: [String] = [
        "Menu-Profile",
        "Menu-Search",
        "Menu-Videochat",
        "Menu-Messages",
        "Menu-Gallery",
        "Menu-Favorites"
    ]
    
    let selectedTabbarImageNames: [String] = [
        "SelectedMenu-Profile",
        "SelectedMenu-Search",
        "SelectedMenu-Videochat",
        "SelectedMenu-Messages",
        "SelectedMenu-Gallery",
        "SelectedMenu-Favorites"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.isTranslucent = false
        tabBar.backgroundColor = .white

        let viewControllers = [
            buildMockViewController(index: 0),
            buildMockViewController(index: 1),
            buildMockViewController(index: 2),
            buildMockViewController(index: 3),
            buildGallery(),
            buildMockViewController(index: 5)
        ]

        setViewControllers(viewControllers, animated: false)
    }
    
    func buildGallery() -> UIViewController {
        let controller = PhotoGridViewController()
        controller.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: tabbarImageNames[4])?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: selectedTabbarImageNames[4])?.withRenderingMode(.alwaysOriginal))
        controller.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        return controller
    }
    
    func buildMockViewController(index: Int) -> UIViewController {
        let controller = UIViewController()
        controller.view.backgroundColor = UIColor(red: CGFloat.random(in: 0..<1),
                                                  green: CGFloat.random(in: 0..<1),
                                                  blue: CGFloat.random(in: 0..<1),
                                                  alpha: 1)
        controller.tabBarItem = UITabBarItem(title: nil,
                                             image: UIImage(named: tabbarImageNames[index])?.withRenderingMode(.alwaysOriginal),
                                             selectedImage: UIImage(named: selectedTabbarImageNames[index])?.withRenderingMode(.alwaysOriginal))
        controller.tabBarItem.imageInsets = UIEdgeInsets(top: 8, left: 0, bottom: -8, right: 0)
        return controller
    }
}
