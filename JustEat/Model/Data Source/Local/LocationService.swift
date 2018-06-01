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
    
    private var locationObserver: AtomicObserver<CLLocation, LocationError>?
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        return manager
    }()
    
    func requestLocation() -> Signal<CLLocation, LocationError> {
        return Signal<CLLocation, LocationError> { [weak self] observer in
            switch CLLocationManager.authorizationStatus() {
            case .authorizedAlways, .authorizedWhenInUse:
                self?.locationObserver = observer
                self?.locationManager.requestLocation()
            case .notDetermined:
                self?.locationObserver = observer
                self?.locationManager.requestWhenInUseAuthorization()
            case .denied:
                observer.failed(.denied)
            case .restricted:
                observer.failed(.restricted)
            }
            
            return BlockDisposable {
                self?.locationObserver = nil
            }
        }
    }
    
}

extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        locationObserver?.completed(with: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationObserver?.failed(.manager(error: error))
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
