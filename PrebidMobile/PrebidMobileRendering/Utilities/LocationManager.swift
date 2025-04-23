//
// Copyright 2018-2025 Prebid.org, Inc.

// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at

// http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing, software
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation
import CoreLocation
import UIKit

@objc(PBMLocationManager) @_spi(PBMInternal) public
class LocationManager: NSObject, CLLocationManagerDelegate {
    @objc public static let shared = LocationManager()
    
    static let distanceFilter = 50.0
    
    private var location: CLLocation?
    private let locationManager: LocationManagerProtocol
    
    var notificationTokens = [NSObjectProtocol]()
    
    convenience init(currentThread: ThreadProtocol = Thread.current) {
        let locationManager: CLLocationManager
        
        // CLLocationManager must be initialized on the main thread
        if currentThread.isMainThread {
            locationManager = CLLocationManager()
        } else {
            locationManager = DispatchQueue.main.sync {
                CLLocationManager()
            }
        }
        self.init(locationManager: locationManager)
    }
    
    init(locationManager: LocationManagerProtocol) {
        locationManager.distanceFilter = Self.distanceFilter
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        self.locationManager = locationManager
        
        super.init()
        
        locationManager.delegate = self
        
        startLocationUpdates()
        
        // CLLocationManager's `location` property may already contain location data upon
        // initialization (for example, if the application uses significant location updates).
        if let existingLocation = locationManager.location, locationIsValid(existingLocation) {
            location = existingLocation
        }
        
        notificationTokens.append(
            NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification,
                                                   object: UIApplication.shared,
                                                   queue: .main) { [weak self] _ in
                                                       self?.stopLocationUpdates()
                                                   })
        
        // Re-activate location updates when the application comes back to the foreground.
        notificationTokens.append(
            NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification,
                                                   object: UIApplication.shared,
                                                   queue: .main) { [weak self] _ in
                                                       self?.startLocationUpdates()
                                                   })
    }
    
    private var _locationUpdatesEnabled = true
    var locationUpdatesEnabled: Bool {
        get { _locationUpdatesEnabled }
        set {
            guard _locationUpdatesEnabled != newValue else {
                return
            }
            _locationUpdatesEnabled = newValue
            
            if (_locationUpdatesEnabled) {
                startLocationUpdates()
            } else {
                stopLocationUpdates()
                location = nil
            }
        }
    }
    
    private var validLocation: CLLocation? {
        if let location, locationIsValid(location) {
            return location
        }
        return nil
    }
    
    @objc public var coordinatesAreValid: Bool {
        validLocation != nil
    }
    
    @objc public var coordinates: CLLocationCoordinate2D {
        validLocation?.coordinate ?? kCLLocationCoordinate2DInvalid
    }
    
    @objc public var horizontalAccuracy: CLLocationAccuracy {
        validLocation?.horizontalAccuracy ?? -1
    }
    
    @objc public var timestamp: Date? {
        validLocation?.timestamp
    }
    
    func isAuthorized(status: CLAuthorizationStatus) -> Bool {
        switch status {
            case .authorizedAlways, .authorizedWhenInUse:
                return true
            case .notDetermined, .denied, .restricted:
                return false
            @unknown default:
                return false
        }
    }
    
    func locationIsValid(_ location: CLLocation) -> Bool {
        CLLocationCoordinate2DIsValid(location.coordinate) && location.horizontalAccuracy > 0
    }
    
    func startLocationUpdates() {
        guard locationUpdatesEnabled,
              isAuthorized(status: locationManager._authorizationStatus)
        else {
            return
        }
        
        locationManager.startUpdatingLocation()
    }
    
    func stopLocationUpdates() {
        locationManager.stopUpdatingLocation()
    }
    
    // MARK: - CLLocationManagerDelegate
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) { //!OCLINT(unused method parameter)
        if let newLocation = locations.last,
           locationIsValid(newLocation) {
            location = newLocation
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) { //!OCLINT(unused method parameter)
        stopLocationUpdates()
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) { //!OCLINT(unused method parameter)
        if isAuthorized(status: status) {
            startLocationUpdates()
        }
    }
    
}
