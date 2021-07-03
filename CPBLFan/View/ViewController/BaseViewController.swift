//
//  BaseViewController.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2020/2/15.
//  Copyright © 2020 Sparkr. All rights reserved.
//

import UIKit
import PKHUD
import Reachability

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // check net connection
        guard let reachability = try? Reachability(), reachability.connection != .unavailable else {
            self.performAlert(with: "網路連線異常。")
            return
        }
        
        // set navigation bar
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem.noTitleBarButtonItem()
        
        // show loading activity view
        HUD.show(.progress)
    }
    
    func performAlert(with message: String?) {
        let alertMessage = message ?? "發生錯誤，請稍後再試。"
        if HUD.isVisible {
            HUD.hide(animated: true, completion: { _ in
                UIAlertController(title: "提示", message: alertMessage).show()
            })
            
        } else {
            UIAlertController(title: "提示", message: alertMessage).show()
        }
    }
    
    func performAnimation(of view: UIView?, isHidden: Bool) {
        HUD.hide(animated: true, completion: { _ in
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, animations: {
                view?.alpha = (isHidden) ? 0 : 1
            })
        })
    }
}
