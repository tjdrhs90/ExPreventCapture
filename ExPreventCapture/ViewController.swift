//
//  ViewController.swift
//  ExPreventCapture
//
//  Created by sgsim on 2022/11/30.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var greenView: UIView!
    @IBOutlet weak var blueView: UIView!
    @IBOutlet weak var yellowView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        greenView.makeSecure()
//        blueView.makeSecure()
        yellowView.makeSecure(addPlaceholder: true)
    }
    
}


extension UIView {
    /// 화면 캡쳐 방지
    ///
    /// https://ios-development.tistory.com/1145
    /// - Parameter addPlaceholder: 캡쳐된 화면에 플레이스홀더 표시할 것인지
    func makeSecure(addPlaceholder: Bool = false) {
        DispatchQueue.main.async {
            
            if addPlaceholder,
               let superview = self.superview {
                
                let placeholderView = UIView()
                placeholderView.backgroundColor = .lightGray
                
                superview.insertSubview(placeholderView, belowSubview: self)
                placeholderView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    placeholderView.topAnchor.constraint(equalTo: self.topAnchor),
                    placeholderView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                    placeholderView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                    placeholderView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
                ])
                
                let lbl = UILabel()
                lbl.textColor = .white
                lbl.textAlignment = .center
                lbl.text = "보안정책에 의해 캡쳐가 제한됩니다."
                lbl.numberOfLines = 0
                
                placeholderView.addSubview(lbl)
                lbl.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    lbl.topAnchor.constraint(equalTo: placeholderView.topAnchor),
                    lbl.bottomAnchor.constraint(equalTo: placeholderView.bottomAnchor),
                    lbl.leadingAnchor.constraint(equalTo: placeholderView.leadingAnchor),
                    lbl.trailingAnchor.constraint(equalTo: placeholderView.trailingAnchor)
                ])
                lbl.adjustsFontSizeToFitWidth = true
                lbl.minimumScaleFactor = 0.2
            }
            
            let textField = UITextField()
            textField.isSecureTextEntry = true
            
            self.addSubview(textField)
            textField.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            textField.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            
            // 캡쳐하려는 뷰의 레이어를 textField.layer 사이에 끼워넣기
            textField.layer.removeFromSuperlayer() // 이 코드가 없으면 run time error (layer 참조 관계에 cycle이 생성되므로)
            //self.layer.superlayer?.insertSublayer(textField.layer, at: 0)
            self.layer.superlayer?.addSublayer(textField.layer) //같은 레벨의 뷰 뒷단에 플레이스홀더 뷰를 넣기 위해 위처럼 insert 첫번째 말고 맨뒤에 add 로 변경
            textField.layer.sublayers?.last?.addSublayer(self.layer)
        }
    }
    
}
