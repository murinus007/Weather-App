//
//  SelectLocationViewController.swift
//  Weather App
//
//  Created by Alexey Sergeev on 03.11.2021.
//

import UIKit
import CoreLocation

protocol MainViewControllerDelegate: AnyObject {
    func didTapPlace(with location: CLLocation)
}

class SelectLocationsViewController: UIViewController, UISearchResultsUpdating {
    let searchVC = UISearchController(searchResultsController: ResultsViewController())
    weak var delegate: MainViewControllerDelegate?
    
    private var places: [Place] = []
    
    private let tableView: UITableView = {
        let table = UITableView()
      
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    override func viewDidLoad() {
        navigationItem.leftBarButtonItem = .init(title: "back", style: .done, target: self, action: #selector(close))
        searchVC.searchResultsUpdater = self
        navigationItem.searchController = searchVC
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.frame
        
        places = getPlaces()
        navigationItem.hidesSearchBarWhenScrolling = false
        tableView.reloadData()

    }
    
    @objc func close() {
        navigationController?.dismiss(animated: true)
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
    
    func getPlaces() -> [Place] {
        if let data = UserDefaults.standard.data(forKey: "places") {
            do {
                let decoder = JSONDecoder()
                let places = try decoder.decode([Place].self, from: data)
                return places
            } catch {
                print("Unable to Decode Place (\(error))")
            }
        }
        return []
    }
    
    func store(place: Place) {
        
        do {
            let encoder = JSONEncoder()
            var places = getPlaces()
            places.append(place)
            let data = try encoder.encode(places)
            UserDefaults.standard.set(data, forKey: "places")

        } catch {
            print("Unable to Encode Place (\(error))")
        }
    }
    
    func delete(place: Place) {
        do {
        let encoder = JSONEncoder()
        places.removeAll { $0.id == place.id }
        let data = try encoder.encode(places)
        UserDefaults.standard.set(data, forKey: "places")
        } catch {
            print("Unable to Encode Place (\(error))")
        }
    }
}

extension SelectLocationsViewController: ResultsViewControllerDelegate {
    func didTapPlace(with place: Place) {
        store(place: place)
        GooglePlacesManager.shared.resolveLocation(for: place) { [weak self] result in
            switch result {
            case .success(let location):
                DispatchQueue.main.async {
                    self?.delegate?.didTapPlace(with: location)
                }
            case .failure(let error):
                print(error)
            }
        }
        
        navigationController?.dismiss(animated: true)
    }
}

extension SelectLocationsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = places[indexPath.row].name
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.isHidden = true
        let place = places[indexPath.row]
        GooglePlacesManager.shared.resolveLocation(for: place) { [weak self] result in
            switch result {
            case .success(let location):
                DispatchQueue.main.async {
                    self?.delegate?.didTapPlace(with: location)
                    self?.navigationController?.dismiss(animated: true)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            delete(place: places[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
        }
    }
}
