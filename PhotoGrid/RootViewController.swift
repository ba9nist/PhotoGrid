//
//  RootViewController.swift
//  PhotoGrid
//
//  Created by Yevhenii Boryspolets on 29.11.2023.
//

import UIKit

class RootViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        transitionToFirstView()
    }

    private func transitionToFirstView() {
        let firstVC = CustomTabbarController()

        setOverrideTraitCollection(UITraitCollection(horizontalSizeClass: .regular),
                                   forChild: firstVC)

        addChild(firstVC)
        view.addSubview(firstVC.view)
        firstVC.didMove(toParent: self)
    }
}
