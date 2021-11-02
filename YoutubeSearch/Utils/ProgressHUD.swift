//
//  ProgressHUD.swift
//  YoutubeSearch
//
//  Created by Admin on 2021/11/2.
//

import Foundation
import JGProgressHUD
import UIKit

class ProgressHUD {
    static let shared = ProgressHUD()
    let hud = JGProgressHUD(style: .light)
    
    private init() {}
    
    func show(view: UIView, msg: String) {
        hud.textLabel.text = msg
        hud.show(in: view)
    }
    
    func dismiss() {
        hud.dismiss()
    }
}
