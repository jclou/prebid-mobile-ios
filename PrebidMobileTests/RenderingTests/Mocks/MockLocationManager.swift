/*   Copyright 2018-2021 Prebid.org, Inc.
 
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at
 
  http://www.apache.org/licenses/LICENSE-2.0
 
  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
  */

import CoreLocation

@testable @_spi(PBMInternal) import PrebidMobile

class MockLocationManager: LocationManager {
    let mock_locationManager: MockCLLocationManager
    
    init() {
        let location = MockCLLocation(latitude: 34.149335, longitude: -118.1328249)
        location.mock_horizontalAccuracy = 10
        location.mock_verticalAccuracy = 10
        
        mock_locationManager = MockCLLocationManager(location: location)
        super.init(locationManager: mock_locationManager)
    }
    
    class MockCLLocationManager: NSObject, LocationManagerProtocol {
        var delegate: (any CLLocationManagerDelegate)?
        var location: CLLocation?
        var distanceFilter: CLLocationDistance = .zero
        var desiredAccuracy: CLLocationAccuracy = .zero
        var _authorizationStatus: CLAuthorizationStatus = .notDetermined
        func startUpdatingLocation() {}
        func stopUpdatingLocation() {}
        
        init(location: CLLocation?) {
            self.location = location
        }
    }
    
    class MockCLLocation: CLLocation, @unchecked Sendable {
        var mock_horizontalAccuracy: CLLocationAccuracy?
        override var horizontalAccuracy: CLLocationAccuracy {
            mock_horizontalAccuracy ?? super.horizontalAccuracy
        }
        
        var mock_verticalAccuracy: CLLocationAccuracy?
        override var verticalAccuracy: CLLocationAccuracy {
            mock_verticalAccuracy ?? super.verticalAccuracy
        }
    }
}
