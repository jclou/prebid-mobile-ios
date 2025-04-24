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

@_spi(PBMInternal) public
typealias AdUnitConfigValidationBlock = (_ adUnitConfig: AdUnitConfig, _ renderWithPrebid: Bool) -> Bool

@objc(PBMAdLoadFlowController) @_spi(PBMInternal) public
protocol AdLoadFlowController: AdLoaderFlowDelegate {
    
    /// Lock protecting the internal state of AdLoadFlowController.
    var mutationLock: NSLock { get }
    
    /// Queue on which internal state of AdLoadFlowController is mutated
    var dispatchQueue: DispatchQueue { get }
    
    /// Whether the last ad loading attempt has failed and there is no current one.
    /// Should only be access
    var hasFailedLoading: Bool { get }
    
    // State: DemandReceived
    var bidResponse: BidResponse? { get set }
    
    init(bidRequesterFactory: @escaping (_ adUnitConfig: AdUnitConfig) -> BidRequesterProtocol,
         adLoader: AdLoaderProtocol,
         adUnitConfig: AdUnitConfig,
         delegate: AdLoadFlowControllerDelegate,
         configValidationBlock: @escaping AdUnitConfigValidationBlock)
    
    /// Starts new flow of loading the ad (if idle or failed) or continues previously paused flow
    func refresh()
    
    /// Allows to update external state on the same serial dispatch queue as AdLoadFlowController's state mutations.
    /// 'mutationLock' is automatically locked before invoking the provided block, and unlocked afterwards.
    func enqueueGatedBlock(_ block: @escaping VoidBlock)
    
}
