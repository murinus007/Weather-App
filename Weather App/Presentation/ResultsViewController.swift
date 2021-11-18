//
//  ResultsViewController.swift
//  Weather App
//
//  Created by Alexey Sergeev on 03.11.2021.
//

import UIKit
import CoreLocation

protocol ResultsViewControllerDelegate: AnyObject {
    func didTapPlace(with location: CLLocation)
}

class ResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let array: [[String]] = [["Lesha", "Doom"], ["Vika"], ["sazimay"]]
    
    weak var delegate: ResultsViewControllerDelegate?
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private var places: [Place] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        view.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    public func update(with places: [Place]) {
        tableView.isHidden = false
        self.places = places
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array[section].count
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
                }
            case .failure(let error):
                print(error)
            }
        }
        
    }
}
