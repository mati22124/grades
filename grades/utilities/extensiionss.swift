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
    
    
    func averageToGrade(settings: UserSettings? = nil) -> String {
        let gradingScale = settings?.gradingScale ?? GradingScale.defaultScale
        let score = settings?.roundForLetterGrade == true ? self.rounded() : self
        
        if score >= gradingScale.aPlus {
            return "A+"
        } else if score >= gradingScale.a {
            return "A"
        } else if score >= gradingScale.aMinus {
            return "A-"
        } else if score >= gradingScale.bPlus {
            return "B+"
        } else if score >= gradingScale.b {
            return "B"
        } else if score >= gradingScale.bMinus {
            return "B-"
        } else if score >= gradingScale.cPlus {
            return "C+"
        } else if score >= gradingScale.c {
            return "C"
        } else if score >= gradingScale.cMinus {
            return "C-"
        } else if score >= gradingScale.dPlus {
            return "D+"
        } else if score >= gradingScale.d {
            return "D"
        } else if score >= gradingScale.dMinus {
            return "D-"
        } else {
            return "F"
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

struct Menuu: AlignmentID {
    static func defaultValue(in context: ViewDimensions) -> CGFloat {
        return context.width / 2
    }
}
extension HorizontalAlignment {
    static let menu = Self(Menuu.self)
}

extension UIImage {
    
    var base64: String? {
        var resizedImageData = self.jpegData(compressionQuality: 0.7)
        
        while(resizedImageData!.count >= 5_242_880) {
            resizedImageData = UIImage(data: resizedImageData!)?.jpegData(compressionQuality: 0.7)
        }
        
        return resizedImageData!.base64EncodedString()
    }
}

extension String {
    func isEmail() -> Bool {
        let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: self)
    }
    
    func strTodowNum() -> Int {
        switch self {
        case "Mon": return 2
        case "Tue": return 3
        case "Wed": return 4
        case "Thu": return 5
        case "Fri": return 6
        case "Sat": return 7
        case "Sun": return 1
        default: return 0  // or throw an error if you prefer
        }
    }
}
