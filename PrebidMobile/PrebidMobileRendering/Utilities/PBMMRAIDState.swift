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

@objc @_spi(PBMInternal) public
class PBMMRAIDState: NSObject, RawRepresentable {
    public typealias RawValue = String
    
    @objc public var rawValue: String
    
    public required init(rawValue: String) {
        self.rawValue = rawValue
    }
    
    @objc public static let notEnabled      = PBMMRAIDState(rawValue: "not_enabled")
    @objc public static let defaultState    = PBMMRAIDState(rawValue: "default")
    @objc public static let expanded        = PBMMRAIDState(rawValue: "expanded")
    @objc public static let hidden          = PBMMRAIDState(rawValue: "hidden")
    @objc public static let loading         = PBMMRAIDState(rawValue: "loading")
    @objc public static let resized         = PBMMRAIDState(rawValue: "resized")
    
    public override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? PBMMRAIDState else {
            return false
        }
        
        return rawValue == other.rawValue
    }
}
