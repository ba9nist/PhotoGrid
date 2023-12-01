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
        controller.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: tabbarImageNames[4])?.withRenderingMode(.alwaysOriginal), selectedImage: nil)
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
                                             selectedImage: nil)
        return controller
    }
}
