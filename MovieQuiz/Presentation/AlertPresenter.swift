import UIKit

protocol AlertProtocol: AnyObject {
    func show(alertModel: AlertModel)
}

final class AlertPresenter: AlertProtocol  {
    
    private weak var viewController: UIViewController?
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func show(alertModel: AlertModel) {
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert)
        alert.view.accessibilityIdentifier = "Game results"
        let action = UIAlertAction(
            title: alertModel.buttonText,
            style: .default,
            handler: alertModel.completion)
        alert.addAction(action)
        viewController?.present(alert, animated: true)
    }
}

