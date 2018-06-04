//
//  RestaurantsDataModelSpec.swift
//  JustEatTests
//
//  Created by Ivan Tkachenko on 6/1/18.
//  Copyright © 2018 ivantkachenko. All rights reserved.
//

import Quick
import Nimble
import ReactiveKit
import CoreLocation
@testable import JustEat

struct MockRestaurantsRemoteDataSource: RestaurantsRemoteDataSource {
    
    let block: (_ zipCode: String) -> Signal<[Restaurant], ApiError>
    
    init(with block: @escaping (_ zipCode: String) -> Signal<[Restaurant], ApiError> = { _ in Signal.completed() }) {
        self.block = block
    }
    
    func queryRestaurants(zipCode: String) -> Signal<[Restaurant], ApiError> {
        return block(zipCode)
    }
    
}

struct MockRestaurantsLocationDataSource: RestaurantsLocationDataSource {
    
    let block: () -> Signal<String, LocationError>
    
    init(with block: @escaping () -> Signal<String, LocationError> = { Signal.completed() }) {
        self.block = block
    }
    
    func requestZipCode() -> Signal<String, LocationError> {
        return block()
    }
    
}

class RestaurantsDataModelSpec: QuickSpec {
    
    override func spec() {
        let bag = self.bag
        var dataModel: RestaurantsDataModel!
        
        describe("requesting restaurants for zip code") {
            context("when there's no restaurants", {
                beforeEach {
                    dataModel = RestaurantsDataModel(remoteDataSource: MockRestaurantsRemoteDataSource { _ in
                        Signal.just([])
                    }, locationDataSource: MockRestaurantsLocationDataSource())
                }
                
                it("emits an empty array") {
                    dataModel.queryRestaurants(zipCode: "")
                        .expect(events: [.next([]), .completed])
                        .dispose(in: bag)
                }
            })
            
            context("when there's restaurants", {
                let restaurant = Restaurant.mock()
                
                beforeEach {
                    dataModel = RestaurantsDataModel(remoteDataSource: MockRestaurantsRemoteDataSource { _ in
                        Signal.just([restaurant])
                    }, locationDataSource: MockRestaurantsLocationDataSource())
                }
                
                it("emits an array of restaurants") {
                    dataModel.queryRestaurants(zipCode: "00000")
                        .expect(events: [.next([restaurant]), .completed])
                        .dispose(in: bag)
                }
            })
            
            context("when there's error") {
                let error = NSError()
                
                beforeEach {
                    dataModel = RestaurantsDataModel(remoteDataSource: MockRestaurantsRemoteDataSource { _ in
                        Signal.failed(.networkError(error: error))
                    }, locationDataSource: MockRestaurantsLocationDataSource())
                }
                
                it("emits failure") {
                    dataModel.queryRestaurants(zipCode: "")
                        .expect(events: [.failed(.api(error: .networkError(error: error)))])
                        .dispose(in: bag)
                }
            }
        }
        
        describe("requesting current zip code") {
            context("when Location Services access denied") {
                beforeEach {
                    dataModel = RestaurantsDataModel(remoteDataSource: MockRestaurantsRemoteDataSource(), locationDataSource: MockRestaurantsLocationDataSource {
                        Signal.failed(.denied)
                    })
                    
                    it("emits access denied error") {
                        dataModel.queryZipCode()
                            .expect(events: [.failed(.location(error: .denied))])
                            .dispose(in: bag)
                    }
                }
            }
            
            context("when there's current location with postal code") {
                let zipCode = "W1J"

                beforeEach {
                    dataModel = RestaurantsDataModel(remoteDataSource: MockRestaurantsRemoteDataSource(), locationDataSource: MockRestaurantsLocationDataSource {
                        Signal.just(zipCode)
                    })
                }
                
                it("emits zip code") {
                    dataModel.queryZipCode()
                        .expect(events: [.next(zipCode), .completed])
                        .dispose(in: bag)
                }
            }
        }
    }
    
}
