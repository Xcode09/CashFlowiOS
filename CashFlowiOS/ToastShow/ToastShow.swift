//
//  ToastShow.swift
//  CashFlowiOS
//
//  Created by Muhammad Ali on 19/02/2021.
//

import Toast_Swift
import UIKit
class Toast {
    public static func showToast(superView:UIView,message:String)
    {
        superView.makeToast(message)

        // toast with a specific duration and position
//        superView.makeToast("This is a piece of toast", duration: 3.0, position: .bottom)

        // toast presented with multiple options and with a completion closure
//        superView.makeToast("This is a piece of toast", duration: 2.0, point: CGPoint(x: 110.0, y: 110.0), title: "Toast Title", image: UIImage(named: "toast.png")) { didTap in
//            if didTap {
//                print("completion from tap")
//            } else {
//                print("completion without tap")
//            }
//        }

        // display toast with an activity spinner
        //superView.makeToastActivity(.center)

        // display any view as toast
        //superView.showToast(myView)

        // immediately hides all toast views in self.view
        //superView.hideAllToasts()
    }
    
    
    static func showActivity(superView:UIView){
        superView.makeToastActivity(.center)
        superView.isUserInteractionEnabled = false
    }
    static func dismissActivity(superView:UIView){
        superView.hideToastActivity()
        superView.isUserInteractionEnabled = true
    }
}
