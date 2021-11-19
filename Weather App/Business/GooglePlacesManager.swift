//
//  GooglePlacesManager.swift
//  Weather App
//
//  Created by Alexey Sergeev on 04.11.2021.
//

import Foundation
import GooglePlaces
import CoreLocation


final class GooglePlacesManager {
    static let shared = GooglePlacesManager()
    
    private let client = GMSPlacesClient.shared()
    
    private init() {}
    
    enum PlacesError: Error {
        case failedToFind
        case failedToGetCoordinates
    }
    
    public func findPlaces(query: String, completion: @escaping (Result<[Place], Error>) -> Void) {
        let filter = GMSAutocompleteFilter()
        filter.type = .city
        client.findAutocompletePredictions(fromQuery: query,
                                           filter: filter,
                                           sessionToken: nil) { results, error in
            guard let results = results, error == nil else {
                completion(.failure(PlacesError.failedToFind))
                return
            }
            
            let places: [Place] = results.map { item in
                Place(name: item.attributedFullText.string, id: item.placeID)
            }
            
            completion(.success(places))
        }
    }
    
    public func resolveLocation(for place: Place, completion: @escaping(Result<CLLocation, Error>) -> Void) {
        client.fetchPlace(fromPlaceID: place.id, placeFields: .coordinate, sessionToken: nil) { googlePlace, error in
            guard let googlePlace = googlePlace, error == nil else {
                completion(.failure(PlacesError.failedToGetCoordinates))
                return
            }
            
            let location = CLLocation(latitude: googlePlace.coordinate.latitude, longitude: googlePlace.coordinate.longitude)
            completion(.success(location))
        }
        
    }
}
