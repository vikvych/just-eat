//
//  JustEatSpec.swift
//  JustEatTests
//
//  Created by Ivan Tkachenko on 6/3/18.
//  Copyright © 2018 ivantkachenko. All rights reserved.
//

import Foundation
import CoreLocation
import Alamofire
import ReactiveKit
import Quick
import Nimble
@testable import JustEat

private struct MockContainer: RestaurantsDataModelContainer {
    
    let restaurantsDataModel: RestaurantsDataModel
    
}

class JustEatSpec: QuickSpec {
    
    override func spec() {
        let bag = self.bag
        var viewModel: RestaurantsViewModel!
        
        describe("using real API") {
            describe("search by zip code") {
                context("when entred valid zip code") {
                    let zipCode = "se19"
                    
                    beforeEach {
                        let dataModel = RestaurantsDataModel(remoteDataSource: ApiService(), locationDataSource: MockRestaurantsLocationDataSource())
                        
                        viewModel = RestaurantsViewModel(with: MockContainer(restaurantsDataModel: dataModel))
                    }
                    
                    it("emits loading state, then restaurants list") {
                        var emittedLoading = false
                        var emittedLoaded = false
                        
                        viewModel.restaurants(queryNearestSignal: Signal.never())
                            .observe { event in
                                guard case .next(let state) = event else { return XCTFail() }
                                
                                switch state {
                                case .loading:
                                    emittedLoading = true
                                case .loaded(let items):
                                    expect(items).toNot(beEmpty())
                                    emittedLoaded = true
                                case .failed:
                                    XCTFail()
                                }
                            }
                            .dispose(in: bag)
                        
                        viewModel.zipCode.value = zipCode
                        expect(emittedLoading).toEventually(beTrue())
                        expect(emittedLoaded).toEventually(beTrue(), timeout: 5)
                    }
                    
                    it("updates zip code title") {
                        var titleEqualsZipCode = false
                        
                        viewModel.zipCode.value = zipCode
                        viewModel.zipCodeTitle()
                            .observe { event in
                                guard case .next(let code) = event else { return }
                                
                                titleEqualsZipCode = code == zipCode.uppercased()
                            }
                            .dispose(in: bag)
                        
                        expect(titleEqualsZipCode).toEventually(beTrue())
                    }
                }
                
                context("when entred wrong zip code") {
                    let zipCode = "04100"

                    beforeEach {
                        let dataModel = RestaurantsDataModel(remoteDataSource: ApiService(), locationDataSource: MockRestaurantsLocationDataSource())
                        
                        viewModel = RestaurantsViewModel(with: MockContainer(restaurantsDataModel: dataModel))
                    }
                    
                    it("emits loading state, then empty list") {
                        var emittedLoading = false
                        var emittedLoaded = false
                        
                        viewModel.restaurants(queryNearestSignal: Signal.never())
                            .observe { event in
                                guard case .next(let state) = event else { return XCTFail() }
                                
                                switch state {
                                case .loading:
                                    emittedLoading = true
                                case .loaded(let items):
                                    expect(items).to(beEmpty())
                                    emittedLoaded = true
                                case .failed:
                                    XCTFail()
                                }
                            }
                            .dispose(in: bag)
                        
                        viewModel.zipCode.value = zipCode
                        expect(emittedLoading).toEventually(beTrue())
                        expect(emittedLoaded).toEventually(beTrue(), timeout: 5)
                    }
                    
                    it("updates zip code title") {
                        var titleEqualsZipCode = false
                        
                        viewModel.zipCode.value = zipCode
                        viewModel.zipCodeTitle()
                            .observe { event in
                                guard case .next(let code) = event else { return }
                                
                                titleEqualsZipCode = code == zipCode.uppercased()
                            }
                            .dispose(in: bag)
                        
                        expect(titleEqualsZipCode).toEventually(beTrue())
                    }
                }
                
                context("when received empty network response") {
                    let zipCode = "se19"
                    
                    beforeEach {
                        let dataModel = RestaurantsDataModel(remoteDataSource: MockRestaurantsRemoteDataSource { _ in
                            Signal.failed(.emptyResponse)
                        }, locationDataSource: MockRestaurantsLocationDataSource())
                        
                        viewModel = RestaurantsViewModel(with: MockContainer(restaurantsDataModel: dataModel))
                    }
                    
                    it("emits loading state, then empty response error") {
                        var emittedLoading = false
                        var emittedEmptyResponse = false
                        
                        viewModel.restaurants(queryNearestSignal: Signal.never())
                            .observe { event in
                                guard case .next(let state) = event else { return XCTFail() }
                                
                                switch state {
                                case .loading:
                                    emittedLoading = true
                                case .loaded:
                                    XCTFail()
                                case .failed(let error):
                                    if case .api(let apiError) = error,
                                       case .emptyResponse = apiError {
                                        emittedEmptyResponse = true
                                    } else {
                                        XCTFail()
                                    }
                                }
                            }
                            .dispose(in: bag)
                        
                        viewModel.zipCode.value = zipCode
                        expect(emittedLoading).toEventually(beTrue())
                        expect(emittedEmptyResponse).toEventually(beTrue(), timeout: 5)
                    }
                }
                
                context("when received network error") {
                    let zipCode = "se19"
                    let networkError = NSError()
                    
                    beforeEach {
                        let dataModel = RestaurantsDataModel(remoteDataSource: MockRestaurantsRemoteDataSource { _ in
                            Signal.failed(.networkError(error: networkError))
                        }, locationDataSource: MockRestaurantsLocationDataSource())
                        
                        viewModel = RestaurantsViewModel(with: MockContainer(restaurantsDataModel: dataModel))
                    }
                    
                    it("emits loading state, then network error") {
                        var emittedLoading = false
                        var emittedNetworkError = false
                        
                        viewModel.restaurants(queryNearestSignal: Signal.never())
                            .observe { event in
                                guard case .next(let state) = event else { return XCTFail() }
                                
                                switch state {
                                case .loading:
                                    emittedLoading = true
                                case .loaded:
                                    XCTFail()
                                case .failed(let error):
                                    if case .api(let apiError) = error,
                                       case .networkError = apiError {
                                        emittedNetworkError = true
                                    } else {
                                        XCTFail()
                                    }
                                }
                            }
                            .dispose(in: bag)
                        
                        viewModel.zipCode.value = zipCode
                        expect(emittedLoading).toEventually(beTrue())
                        expect(emittedNetworkError).toEventually(beTrue(), timeout: 5)
                    }
                }
                
                context("when received parse error") {
                    let zipCode = "se19"
                    let networkError = NSError()
                    
                    beforeEach {
                        let dataModel = RestaurantsDataModel(remoteDataSource: MockRestaurantsRemoteDataSource { _ in
                            Signal.failed(.failedToParse(error: networkError))
                        }, locationDataSource: MockRestaurantsLocationDataSource())
                        
                        viewModel = RestaurantsViewModel(with: MockContainer(restaurantsDataModel: dataModel))
                    }
                    
                    it("emits loading state, then parse error") {
                        var emittedLoading = false
                        var emittedNetworkError = false
                        
                        viewModel.restaurants(queryNearestSignal: Signal.never())
                            .observe { event in
                                guard case .next(let state) = event else { return XCTFail() }
                                
                                switch state {
                                case .loading:
                                    emittedLoading = true
                                case .loaded:
                                    XCTFail()
                                case .failed(let error):
                                    if case .api(let apiError) = error,
                                        case .failedToParse = apiError {
                                        emittedNetworkError = true
                                    } else {
                                        XCTFail()
                                    }
                                }
                            }
                            .dispose(in: bag)
                        
                        viewModel.zipCode.value = zipCode
                        expect(emittedLoading).toEventually(beTrue())
                        expect(emittedNetworkError).toEventually(beTrue(), timeout: 5)
                    }
                }
            }
            
            describe("search by current location") {
                context("when Location Service returned valid zipCode") {
                    let zipCode = "W1J"
                    
                    beforeEach {
                        let dataModel = RestaurantsDataModel(remoteDataSource: ApiService(), locationDataSource: MockRestaurantsLocationDataSource {
                            Signal.just(zipCode)
                        })
                        
                        viewModel = RestaurantsViewModel(with: MockContainer(restaurantsDataModel: dataModel))
                    }
                    
                    it("emits loading state, then restaurants list") {
                        var emittedLoading = false
                        var emittedLoaded = false

                        viewModel.restaurants(queryNearestSignal: SafeSignal { observer in
                            observer.next()
                            return NonDisposable.instance
                        })
                            .observe { event in
                                guard case .next(let state) = event else { return XCTFail() }
                                
                                switch state {
                                case .loading:
                                    emittedLoading = true
                                case .loaded(let items):
                                    expect(items).toNot(beEmpty())
                                    emittedLoaded = true
                                case .failed:
                                    XCTFail()
                                }
                            }
                            .dispose(in: bag)
                        
                        expect(emittedLoading).toEventually(beTrue())
                        expect(emittedLoaded).toEventually(beTrue(), timeout: 5)
                    }
                    
                    it("updates zip code title") {
                        var titleEqualsZipCode = false
                        
                        viewModel.zipCode.value = zipCode
                        viewModel.zipCodeTitle()
                            .observe { event in
                                guard case .next(let code) = event else { return }
                                
                                titleEqualsZipCode = code == zipCode.uppercased()
                            }
                            .dispose(in: bag)
                        
                        expect(titleEqualsZipCode).toEventually(beTrue())
                    }
                }
                
                context("when Location Service returned wrong zipCode") {
                    let zipCode = "04100"

                    beforeEach {
                        let dataModel = RestaurantsDataModel(remoteDataSource: ApiService(), locationDataSource: MockRestaurantsLocationDataSource {
                            Signal.just(zipCode)
                        })
                        
                        viewModel = RestaurantsViewModel(with: MockContainer(restaurantsDataModel: dataModel))
                    }
                    
                    it("emits loading state, then empty list") {
                        var emittedLoading = false
                        var emittedLoaded = false
                        
                        viewModel.restaurants(queryNearestSignal: SafeSignal { observer in
                            observer.next()
                            return NonDisposable.instance
                        })
                            .observe { event in
                                guard case .next(let state) = event else { return XCTFail() }
                                
                                switch state {
                                case .loading:
                                    emittedLoading = true
                                case .loaded(let items):
                                    expect(items).to(beEmpty())
                                    emittedLoaded = true
                                case .failed:
                                    XCTFail()
                                }
                            }
                            .dispose(in: bag)
                        
                        expect(emittedLoading).toEventually(beTrue())
                        expect(emittedLoaded).toEventually(beTrue(), timeout: 5)
                    }
                    
                    it("updates zip code title") {
                        var titleEqualsZipCode = false
                        
                        viewModel.zipCode.value = zipCode
                        viewModel.zipCodeTitle()
                            .observe { event in
                                guard case .next(let code) = event else { return }
                                
                                titleEqualsZipCode = code == zipCode.uppercased()
                            }
                            .dispose(in: bag)
                        
                        expect(titleEqualsZipCode).toEventually(beTrue())
                    }
                }
                
                context("when Location Service access denied") {
                    beforeEach {
                        let dataModel = RestaurantsDataModel(remoteDataSource: ApiService(), locationDataSource: MockRestaurantsLocationDataSource {
                            Signal.failed(.denied)
                        })
                        
                        viewModel = RestaurantsViewModel(with: MockContainer(restaurantsDataModel: dataModel))
                    }
                    
                    it("emits loading state, then access denied error") {
                        var emittedLoading = false
                        var emittedAccessDenied = false
                        
                        viewModel.restaurants(queryNearestSignal: SafeSignal { observer in
                            observer.next()
                            return NonDisposable.instance
                        })
                            .observe { event in
                                guard case .next(let state) = event else { return XCTFail() }
                                
                                switch state {
                                case .loading:
                                    emittedLoading = true
                                case .loaded:
                                    XCTFail()
                                case .failed(let error):
                                    if case .location(error: let locationError) = error,
                                       case .denied = locationError {
                                        emittedAccessDenied = true
                                    } else {
                                        XCTFail()
                                    }
                                }
                            }
                            .dispose(in: bag)
                        
                        expect(emittedLoading).toEventually(beTrue())
                        expect(emittedAccessDenied).toEventually(beTrue())
                    }
                    
                    it("updates zipCode title to default") {
                        var titleEqualsDefault = false

                        viewModel.restaurants(queryNearestSignal: SafeSignal { observer in
                            observer.next()
                            return NonDisposable.instance
                        })
                            .observe { _ in }
                            .dispose(in: bag)
                        
                        viewModel.zipCodeTitle()
                            .observe { event in
                                guard case .next(let code) = event else { return }
                                
                                titleEqualsDefault = code == Strings.Restaurants.zipCode
                            }
                            .dispose(in: bag)
                        
                        expect(titleEqualsDefault).toEventually(beTrue())
                    }
                }
                
                context("when Location Service access restricted") {
                    beforeEach {
                        let dataModel = RestaurantsDataModel(remoteDataSource: ApiService(), locationDataSource: MockRestaurantsLocationDataSource {
                            Signal.failed(.restricted)
                        })
                        
                        viewModel = RestaurantsViewModel(with: MockContainer(restaurantsDataModel: dataModel))
                    }
                    
                    it("emits loading state, then access denied error") {
                        var emittedLoading = false
                        var emittedAccessRestricted = false
                        
                        viewModel.restaurants(queryNearestSignal: SafeSignal { observer in
                            observer.next()
                            return NonDisposable.instance
                        })
                            .observe { event in
                                guard case .next(let state) = event else { return XCTFail() }
                                
                                switch state {
                                case .loading:
                                    emittedLoading = true
                                case .loaded:
                                    XCTFail()
                                case .failed(let error):
                                    if case .location(error: let locationError) = error,
                                        case .restricted = locationError {
                                        emittedAccessRestricted = true
                                    } else {
                                        XCTFail()
                                    }
                                }
                            }
                            .dispose(in: bag)
                        
                        expect(emittedLoading).toEventually(beTrue())
                        expect(emittedAccessRestricted).toEventually(beTrue())
                    }
                    
                    it("updates zipCode title to default") {
                        var titleEqualsDefault = false
                        
                        viewModel.restaurants(queryNearestSignal: SafeSignal { observer in
                            observer.next()
                            return NonDisposable.instance
                        })
                            .observe { _ in }
                            .dispose(in: bag)
                        
                        viewModel.zipCodeTitle()
                            .observe { event in
                                guard case .next(let code) = event else { return }
                                
                                titleEqualsDefault = code == Strings.Restaurants.zipCode
                            }
                            .dispose(in: bag)
                        
                        expect(titleEqualsDefault).toEventually(beTrue())
                    }
                }
                
                context("when Location Service not found postal code") {
                    beforeEach {
                        let dataModel = RestaurantsDataModel(remoteDataSource: ApiService(), locationDataSource: MockRestaurantsLocationDataSource {
                            Signal.failed(.postalCodeNotFound)
                        })
                        
                        viewModel = RestaurantsViewModel(with: MockContainer(restaurantsDataModel: dataModel))
                    }
                    
                    it("emits loading state, then access denied error") {
                        var emittedLoading = false
                        var emittedPostalCodeNotFound = false
                        
                        viewModel.restaurants(queryNearestSignal: SafeSignal { observer in
                            observer.next()
                            return NonDisposable.instance
                        })
                            .observe { event in
                                guard case .next(let state) = event else { return XCTFail() }
                                
                                switch state {
                                case .loading:
                                    emittedLoading = true
                                case .loaded:
                                    XCTFail()
                                case .failed(let error):
                                    if case .location(error: let locationError) = error,
                                        case .postalCodeNotFound = locationError {
                                        emittedPostalCodeNotFound = true
                                    } else {
                                        XCTFail()
                                    }
                                }
                            }
                            .dispose(in: bag)
                        
                        expect(emittedLoading).toEventually(beTrue())
                        expect(emittedPostalCodeNotFound).toEventually(beTrue())
                    }
                    
                    it("updates zipCode title to default") {
                        var titleEqualsDefault = false
                        
                        viewModel.restaurants(queryNearestSignal: SafeSignal { observer in
                            observer.next()
                            return NonDisposable.instance
                        })
                            .observe { _ in }
                            .dispose(in: bag)
                        
                        viewModel.zipCodeTitle()
                            .observe { event in
                                guard case .next(let code) = event else { return }
                                
                                titleEqualsDefault = code == Strings.Restaurants.zipCode
                            }
                            .dispose(in: bag)
                        
                        expect(titleEqualsDefault).toEventually(beTrue())
                    }
                }
            }
        }
    }
    
}
