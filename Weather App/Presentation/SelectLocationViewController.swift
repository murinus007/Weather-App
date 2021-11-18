//
//  SelectLocationViewController.swift
//  Weather App
//
//  Created by Alexey Sergeev on 03.11.2021.
//

import UIKit
import CoreLocation

class SelectLocationsViewController: UIViewController, UISearchResultsUpdating {
    let searchVC = UISearchController(searchResultsController: ResultsViewController())
    weak var delegate: ResultsViewControllerDelegate?
    
    override func viewDidLoad() {
        title = "hello"
        searchVC.searchResultsUpdater = self
        navigationItem.searchController = searchVC

        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
        let resultsVC = searchController.searchResultsController as? ResultsViewController else {
                  return
              }
        
        resultsVC.delegate = self
        
        GooglePlacesManager.shared.findPlaces(query: query) { result in
            switch result {
            case .success(let places):
                DispatchQueue.main.async {
                    resultsVC.update(with: places)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension SelectLocationsViewController: ResultsViewControllerDelegate {
    func didTapPlace(with location: CLLocation) {
        delegate?.didTapPlace(with: location)
        navigationController?.dismiss(animated: true)
    }
}
