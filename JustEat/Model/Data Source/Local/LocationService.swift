//
//  LocationService.swift
//  JustEat
//
//  Created by Ivan Tkachenko on 6/1/18.
//  Copyright © 2018 ivantkachenko. All rights reserved.
//

import Foundation
import CoreLocation
import ReactiveKit

class LocationService: NSObject {
    
    private let locationSubject = PublishSubject<CLLocation, LocationError>()
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        return manager
    }()
    
    func requestLocation() -> Signal<CLLocation, LocationError> {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            locationSubject.failed(.denied)
        case .restricted:
            locationSubject.failed(.restricted)
        }
        
        return locationSubject.toSignal()
    }
    
}

extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        manager.stopUpdatingLocation()
        locationSubject.next(location)
    }
    
}

extension LocationService: RestaurantsLocationDataSource {
    
    func requestPlacemark() -> Signal<CLPlacemark, LocationError> {
        return requestLocation()
            .flatMapLatest { location in
                Signal { observer in
                    CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
                        if let placemark = placemarks?.first {
                            observer.completed(with: placemark)
                        } else if let error = error {
                            observer.failed(.geocode(error: error))
                        } else {
                            observer.failed(.postalCodeNotFound)
                        }
                    }
                    
                    return NonDisposable.instance
                }
            }
    }
    
}
