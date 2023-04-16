import UIKit

struct AlertModel {
    let title: String
    let message: String
    let buttontext: String
    var completion: ((UIAlertAction) -> Void)?
}
