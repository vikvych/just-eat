//
//  Common.swift
//  ReactiveKit
//
//  Created by Srdan Rasic on 14/04/16.
//  Copyright © 2016 Srdan Rasic. All rights reserved.
//

import XCTest
import ReactiveKit

extension Event: Equatable where Element: Equatable {
    
    public static func == (lhs: Event, rhs: Event) -> Bool {
        switch (lhs, rhs) {
        case (.completed, .completed):
            return true
        case (.failed, .failed):
            return true
        case (.next(let left), .next(let right)):
            return left == right
        default:
            return false
        }
    }
    
}

extension LoadingState: Equatable where LoadingValue: Equatable {
    
    public static func == (lhs: LoadingState, rhs: LoadingState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case (.failed, .failed):
            return true
        case (.loaded(let left), .loaded(let right)):
            return left == right
        default:
            return false
        }
    }
    
}

extension SignalProtocol where Element: Equatable {
    
    // Synchronous test
    func expectComplete(after expectedElements: [Element],
                        file: StaticString = #file, line: UInt = #line,
                        observer: ((Event<Element, Error>) -> Void)? = nil) -> Disposable {
        return expect(events: expectedElements.map { .next($0) } + [.completed], file: file, line: line, observer: observer)
    }
    
    func expect(events expectedEvents: [Event<Element, Error>],
                file: StaticString = #file, line: UInt = #line,
                observer: ((Event<Element, Error>) -> Void)? = nil) -> Disposable {
        var eventsToProcess = expectedEvents
        var receivedEvents: [Event<Element, Error>] = []
        var matchedAll = false
        
        let disposable = observe { event in
            receivedEvents.append(event)
            
            if eventsToProcess.count == 0 {
                XCTFail("Got more events than expected.")
                return
            }
            
            let expected = eventsToProcess.removeFirst()
            
            XCTAssert(event == expected, "(Got \(receivedEvents) instead of \(expectedEvents))", file: file, line: line)
            
            if eventsToProcess.count == 0 {
                matchedAll = true
            }
            
            observer?(event)
        }
        
        if !matchedAll {
            XCTFail("Got only first \(receivedEvents.count) events of expected \(expectedEvents))", file: file, line: line)
        }
        
        return disposable
    }
    
    func expectNoEvent(file: StaticString = #file, line: UInt = #line) -> Disposable {
        return observe { event in
            XCTFail("Got a \(event) when expected empty", file: file, line: line)
        }
    }
    
    // Asynchronous test
    func expectAsyncComplete(after expectedElements: [Element],
                             expectation: XCTestExpectation,
                             file: StaticString = #file, line: UInt = #line,
                             observer: ((Event<Element, Error>) -> Void)? = nil) -> Disposable {
        return expectAsync(events: expectedElements.map { .next($0) } + [.completed], expectation: expectation, file: file, line: line, observer: observer)
    }
    
    func expectAsync(events expectedEvents: [Event<Element, Error>],
                     expectation: XCTestExpectation,
                     file: StaticString = #file, line: UInt = #line,
                     observer: ((Event<Element, Error>) -> Void)? = nil) -> Disposable {
        XCTAssert(!expectedEvents.isEmpty, "Use expectEmptyAsync for waiting empty signal")
        var eventsToProcess = expectedEvents
        var receivedEvents: [Event<Element, Error>] = []
        
        return observe { event in
            receivedEvents.append(event)
            if eventsToProcess.count == 0 {
                XCTFail("Got more events than expected.")
                return
            }
            let expected = eventsToProcess.removeFirst()
            XCTAssert(event == expected, "(Got \(receivedEvents) instead of \(expectedEvents))", file: file, line: line)
            if eventsToProcess.count == 0 {
                expectation.fulfill()
            }
            observer?(event)
        }
    }
}

class Scheduler {
    private var availableRuns = 0
    private var scheduledBlocks: [() -> Void] = []
    private(set) var numberOfRuns = 0
    
    var context: ExecutionContext {
        return ExecutionContext { block in
            self.scheduledBlocks.append(block)
            self.tryRun()
        }
    }
    
    func runOne() {
        guard availableRuns < Int.max else { return }
        availableRuns += 1
        tryRun()
    }
    
    func runRemaining() {
        availableRuns = Int.max
        tryRun()
    }
    
    private func tryRun() {
        while availableRuns > 0 && scheduledBlocks.count > 0 {
            let block = scheduledBlocks.removeFirst()
            block()
            numberOfRuns += 1
            availableRuns -= 1
        }
    }
}

func ==(lhs: [(String, Int)], rhs: [(String, Int)]) -> Bool {
    if lhs.count != rhs.count {
        return false
    }
    
    return zip(lhs, rhs).reduce(true) { memo, new in
        memo && new.0.0 == new.1.0 && new.0.1 == new.1.1
    }
}

