//
//  SceneDelegate.swift
//  WhatsApp Chat
//
//  Created by Abhishek on 05/07/24.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var mainNav: UINavigationController?
    var sceneDelegate: SceneDelegate? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let delegate = windowScene.delegate as? SceneDelegate else {
            return nil
        }
        
        return delegate
    }


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        if Utility.valueFor(forKey: PreferenceKeys.isLogin.rawValue) as? Bool ?? false {
            mainNav = UINavigationController(rootViewController: HomeViewController(viewModel: HomeViewModel(router: Router())))
//            mainNav = UINavigationController(rootViewController: ProfileInfoViewController(viewModel: ProfileInfoViewModel(router: Router())))
        } else {
            mainNav = UINavigationController(rootViewController: WelcomeVC(welcomeViewModel: WelcomeViewModel(router: Router())))
        }
        
        mainNav?.isNavigationBarHidden = true
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = mainNav
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
        if let userId = Auth.auth().currentUser?.uid {
            userReference.document(userId).updateData([Keys.isOnline: false, Keys.lastSeen: Utility.getCurrentTime()])
            
        }
    }


}

