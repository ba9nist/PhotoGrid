//
//  SceneDelegate.swift
//  PhotoGrid
//
//  Created by Yevhenii Boryspolets on 29.11.2023.
//

import UIKit
import AZTabBar

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: scene.coordinateSpace.bounds)
        window?.windowScene = scene
    
        window?.rootViewController = RootViewController()
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
    func buildTabbarController() -> UIViewController{
        let tabbarImageNames: [String] = [
            "Menu-Profile",
            "Menu-Search",
            "Menu-Videochat",
            "Menu-Messages",
            "Menu-Gallery",
            "Menu-Favorites"
        ]
        
        let images = tabbarImageNames.map{UIImage(named: $0)!}.map{$0.withRenderingMode(.alwaysTemplate)}.map{$0.withTintColor(UIColor(red: 161.0/255.0, green: 181.0/255.0, blue: 209.0/255.0, alpha: 1.0))}
        let selectedImages = tabbarImageNames.map{UIImage(named: $0)!}.map{$0.withRenderingMode(.alwaysTemplate)}.map{$0.withTintColor(UIColor(red: 68.0/255.0, green: 108.0/255.0, blue: 162.0/255.0, alpha: 1.0))}
        
        let viewControllers = [
            buildMockViewController(),
            buildMockViewController(),
            buildMockViewController(),
            buildMockViewController(),
            PhotoGridViewController(),
            buildMockViewController()
        ]
        
        
        
        let controller = AZTabBarController(withTabIcons: selectedImages, highlightedIcons: selectedImages)
        controller.selectionIndicatorHeight = 0
//        controller.defaultColor = .green //UIColor(red: 161.0/255.0, green: 181.0/255.0, blue: 209.0/255.0, alpha: 1.0)
//        controller.selectedColor = .red//UIColor(red: 68.0/255.0, green: 108.0/255.0, blue: 162.0/255.0, alpha: 1.0)
        controller.ignoreIconColors = true
        
        viewControllers.enumerated().forEach{ (index, viewController) in
            controller.setViewController(viewController, atIndex: index)
        }
        
        return controller
    }

    
    func buildMockViewController() -> UIViewController {
        let controller = UIViewController()
        controller.view.backgroundColor = UIColor(red: CGFloat.random(in: 0..<1),
                                                  green: CGFloat.random(in: 0..<1),
                                                  blue: CGFloat.random(in: 0..<1),
                                                  alpha: 1)
        return controller
    }
}

