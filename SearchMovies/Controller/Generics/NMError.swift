//
//  NMError.swift
//  Natalia Macambira
//
//  Created by Natalia on 23/03/17.
//  Copyright © 2017 Natalia Macambira. All rights reserved.
//

import UIKit

final class NMError {
    
    static func errorTitle(responseStatusCode: Int?, error: Error) -> String {
        var title: String? = "Error"
        
        if let statusCode = responseStatusCode {
            switch statusCode {
            case 400...499:
                title = "Permission error"
            case 500...599:
                title = "Server error"
            case -999:
                title = "Request canceled"
            default:
                title = "Unknow error"
            }
            
        } else {
            let errorCode = error as NSError
            switch errorCode.code {
            case -1009:
                title = "Conection error (no internet)"
            case -1001:
                title = "Request time out"
            default:
                title = "Unknow error"
            }
        }
        return title!
    }
    
    static func errorMessage(responseStatusCode: Int?, error: Error) -> String {
        var message: String? = "\(error.localizedDescription)"
        
        if let statusCode = responseStatusCode {
            switch statusCode {
            case 400...499:
                message = "\(error.localizedDescription)"
            case 500...599:
                message = "\(error.localizedDescription)"
            case -999:
                message = "\(error.localizedDescription)"
            default:
                message = "\(error.localizedDescription)"
            }
            
        } else {            
            let errorCode = error as NSError
            switch errorCode.code {
            case -1009:
                message = "\(error.localizedDescription)"
            case -1001:
                message = "\(error.localizedDescription)"
            default:
                message = "\(error.localizedDescription)"
            }
        }
        return message!
    }
}

extension UIViewController {
     func alertNMError(statusCode: Int?, error: Error){
        let title = NMError.errorTitle(responseStatusCode: statusCode, error: error)
        let message = NMError.errorMessage(responseStatusCode: statusCode, error: error)
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        alert.showFromRootViewController()
    }
}

extension UIAlertController {
    func showFromRootViewController() {
        present(animated: true, completion: nil)
    }
    
    func present(animated: Bool, completion: (() -> Void)?) {
        if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
            presentFromController(controller: rootVC, animated: animated, completion: completion)
        }
    }
    
    private func presentFromController(controller: UIViewController, animated: Bool, completion: (() -> Void)?) {
        if let navVC = controller as? UINavigationController,
            let visibleVC = navVC.visibleViewController {
            presentFromController(controller: visibleVC, animated: animated, completion: completion)
        } else
            if let tabVC = controller as? UITabBarController,
                let selectedVC = tabVC.selectedViewController {
                presentFromController(controller: selectedVC, animated: animated, completion: completion)
            } else
                if let presented = controller.presentedViewController {
                    presentFromController(controller: presented, animated: animated, completion: completion)
                } else {
                    controller.present(self, animated: animated, completion: completion)
        }        
    }
}
