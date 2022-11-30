//
//  SceneDelegate.swift
//  ExPreventCapture
//
//  Created by sgsim on 2022/11/30.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    ///녹화 화면
    lazy var recordView: UIView = {
        let backView = UIView()
        
        backView.frame = window?.windowScene?.screen.bounds ?? .zero
        backView.backgroundColor = .black
        
        let lbl = UILabel()
        lbl.text = "보안정책에 의해 녹화가 제한됩니다."
        lbl.numberOfLines = 0
        lbl.textColor = .white
        lbl.textAlignment = .center
        backView.addSubview(lbl)
        lbl.frame = backView.frame
                
        return backView
    }()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        preventScreenCapture()
    }
    
    private func preventScreenCapture() {
        NotificationCenter.default.addObserver(self, selector: #selector(alertCapture), name: UIApplication.userDidTakeScreenshotNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(alertRecoding), name: UIScreen.capturedDidChangeNotification, object: nil)
    }
    @objc private func alertCapture() {
        alert("보안정책에 의해 캡쳐가 제한됩니다.")
    }
    @objc private func alertRecoding() {
        UIScreen.main.isCaptured ? window?.addSubview(recordView) : recordView.removeFromSuperview()
    }
    private func alert(_ title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .cancel, handler: nil)
        alert.addAction(confirm)
        
        if var topController = self.window?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            DispatchQueue.main.async {
                topController.present(alert, animated: false, completion: nil)
            }
        }
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


}

