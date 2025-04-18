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
protocol __PBMInternal_PBMBidRequester_Protocol: PBMBidRequesterProtocol {
    init(connection: PrebidServerConnectionProtocol,
         sdkConfiguration: Prebid,
         targeting: Targeting,
         adUnitConfiguration: AdUnitConfig)
}

@objc(__PBMInternal_PBMBidRequester_Swift) @_spi(PBMInternal) public
class PBMBidRequester: NSObject, __PBMInternal_PBMBidRequester_Protocol {
    typealias Impl = __PBMInternal_PBMBidRequester_Protocol
    static var impl: Impl.Type = { NSClassFromString("PBMBidRequester_Objc") as! Impl.Type }()
    let impl: Impl
    
    init(impl: Impl) {
        self.impl = impl
    }
    
    public required convenience init(connection: any PrebidServerConnectionProtocol,
                                     sdkConfiguration: Prebid,
                                     targeting: Targeting,
                                     adUnitConfiguration: AdUnitConfig) {
        self.init(impl: Self.impl.init(connection: connection,
                                       sdkConfiguration: sdkConfiguration,
                                       targeting: targeting,
                                       adUnitConfiguration: adUnitConfiguration))
    }
    
    public func requestBids(completion: @escaping (BidResponse?, (any Error)?) -> Void) {
        impl.requestBids(completion: completion)
    }
    
}
