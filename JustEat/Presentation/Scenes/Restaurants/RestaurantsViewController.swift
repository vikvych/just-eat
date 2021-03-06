//
//  RestaurantsViewController.swift
//  JustEat
//
//  Created by Ivan Tkachenko on 5/30/18.
//  Copyright © 2018 ivantkachenko. All rights reserved.
//

import UIKit
import ReactiveKit
import Bond
import AlamofireImage

class RestaurantsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var nearestBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var zipCodeBarButtonItem: UIBarButtonItem!
    
    weak var flowCoordinator: FlowCoordinator?
    
    var viewModel: RestaurantsViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.restaurants(queryNearestSignal: nearestBarButtonItem.reactive.tap)
            .consumeLoadingState(by: self)
            .bind(to: tableView) { items, indexPath, tableView in
                let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantCell.reuseIdentifier, for: indexPath) as! RestaurantCell
                
                cell.infoView.setup(with: items[indexPath.row])
                
                return cell
        }
        
        viewModel.zipCodeTitle().bind(to: zipCodeBarButtonItem.reactive.title)
        zipCodeBarButtonItem.reactive.tap
            .bind(to: self) { me in me.showZipCodeInput() }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow, viewModel.items.value.count > indexPath.row else { return }
        
        flowCoordinator?.prepareScene(for: segue, data: viewModel.items.value[indexPath.row])
    }
    
    private func showLoading() {
        activityIndicator.isHidden = false
        infoLabel.text = nil
        setTableViewHidden(true)
    }
    
    private func showEmpty() {
        activityIndicator.isHidden = true
        infoLabel.text = Strings.Restaurants.nothingFound
        infoLabel.textColor = .darkText
        setTableViewHidden(true)
    }
    
    private func showLoaded() {
        activityIndicator.isHidden = true
        setTableViewHidden(false)
    }
    
    private func showFailed(_ error: AppError) {
        activityIndicator.isHidden = true
        infoLabel.text = error.userMessage
        infoLabel.textColor = .red
        setTableViewHidden(true)
        
        if case .location(.denied) = error {
            showLocationDeniedAlert()
        }
    }
    
    private func setTableViewHidden(_ hidden: Bool, animated: Bool = true) {
        let duration: TimeInterval = animated ? 0.25 : 0.0
        
        UIView.transition(with: view, duration: duration, options: [.transitionCrossDissolve], animations: {
            self.tableView.isHidden = hidden
            self.emptyView.isHidden = !hidden
        }, completion: nil)
    }
    
    private func showZipCodeInput() {
        let controller = UIAlertController(title: Strings.Restaurants.searchZipCode, message: nil, preferredStyle: .alert)
        
        controller.addTextField { textField in
            textField.placeholder = Strings.Restaurants.zipCodeSearchHint
        }
        
        controller.addAction(UIAlertAction(title: Strings.Action.cancel, style: .cancel, handler: nil))
        controller.addAction(UIAlertAction(title: Strings.Action.search, style: .default) { [weak controller, weak self] _ in
            guard let text = controller?.textFields?.first?.text else { return }
            
            self?.viewModel.zipCode.value = text
        })
        
        present(controller, animated: true, completion: nil)
    }
    
    private func showLocationDeniedAlert() {
        let controller = UIAlertController(title: Strings.Error.locationDenied, message: Strings.Error.locationDeniedDescription, preferredStyle: .alert)
        
        controller.addAction(UIAlertAction(title: Strings.Action.cancel, style: .cancel, handler: nil))
        controller.addAction(UIAlertAction(title: Strings.Action.settings, style: .default) { _ in
            UIApplication.shared.open(URL(string:UIApplicationOpenSettingsURLString)!)
        })
        
        present(controller, animated: true, completion: nil)
    }
    
}

extension RestaurantsViewController: LoadingStateListener {
    
    func setLoadingState<LoadingValue, LoadingError>(_ state: ObservedLoadingState<LoadingValue, LoadingError>) where LoadingError : Error {
        switch state {
        case .loading, .reloading:
            showLoading()
        case .loaded(let items) where items is [Restaurant]:
            if (items as! [Restaurant]).isEmpty {
                showEmpty()
            } else {
                showLoaded()
            }
        case .failed(let error) where error is AppError:
            showFailed(error as! AppError)
        default:
            break
        }
    }
    
}
