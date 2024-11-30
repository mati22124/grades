//
//  extensiionss.swift
//  grades
//
//  Created by Mayank Tiku on 9/26/24.
//
import SwiftUI
import AuthenticationServices


extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

extension UIViewController: @retroactive ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

extension View {
    @available(iOS 14, *)
    func navigationBarTitleTextColor(_ color: Color) -> some View {
        let uiColor = UIColor(color)
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: uiColor ]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: uiColor ]
        return self
    }
}

extension Double {
    func removeZerosFromEnd() -> String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 16 //maximum digits in Double after dot (maximum precision)
        return String(formatter.string(from: number) ?? "")
    }
    
    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    func roundedGrade() -> String {
        return String(format: "%.2f", self.round(to: 2))
    }
    
    
    func averageToGrade() -> String {
        if (self >= 93) {
            return "A";
        } else if (self >= 90) {
            return "A-";
        } else if (self >= 87) {
            return "B+";
        } else if (self >= 83) {
            return "B";
        } else if (self >= 80) {
            return "B-";
        } else if (self >= 77) {
            return "C+";
        } else if (self >= 73) {
            return "C";
        } else if (self >= 70) {
            return "C-";
        } else if (self >= 67) {
            return "D+";
        } else if (self >= 63) {
            return "D";
        } else if (self >= 60) {
            return "D-";
        } else {
            return "F";
        }
    }

}

public struct RemoveFocusOnTapModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
            }
    }
}

extension View {
    public func removeFocusOnTap() -> some View {
        modifier(RemoveFocusOnTapModifier())
    }
}

struct Menu: AlignmentID {
    static func defaultValue(in context: ViewDimensions) -> CGFloat {
        return context.width / 2
    }
}
extension HorizontalAlignment {
    static let menu = Self(Menu.self)
}
