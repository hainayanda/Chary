//
//  DispatchQueueSpec.swift
//  Chary_Tests
//
//  Created by Nayanda Haberty on 01/06/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Chary

class DispatchQueueSpec: QuickSpec {
    
    override func spec() {
        describe("system queue") {
            var queues: [DispatchQueue]!
            beforeEach {
                queues = [
                    DispatchQueue.main, DispatchQueue.global(),
                    DispatchQueue.global(qos: .background), DispatchQueue.global(qos: .default),
                    DispatchQueue.global(qos: .unspecified), DispatchQueue.global(qos: .userInitiated),
                    DispatchQueue.global(qos: .userInteractive), DispatchQueue.global(qos: .utility)
                ]
            }
            it("should get current system queue") {
                for queue in queues {
                    let detection = queue.safeSync { DispatchQueue.current }
                    expect(detection).to(equal(queue))
                }
            }
        }
        describe("custom queue") {
            var queue: DispatchQueue!
            beforeEach {
                queue = DispatchQueue(label: UUID().uuidString)
            }
            context("unregistered") {
                it("should not detect unregistered queue") {
                    let detection = queue.sync { DispatchQueue.current }
                    expect(queue).toNot(equal(detection))
                }
            }
            context("registered") {
                beforeEach {
                    queue.registerDetection()
                }
                it("should get registered a detection") {
                    let detection = queue.sync { DispatchQueue.current }
                    expect(detection).to(equal(queue))
                }
                it("should run first block if in different queue") {
                    let inDifferentQueue = queue.ifAtDifferentQueue {
                        true
                    } ifNot: {
                        false
                    }
                    expect(inDifferentQueue).to(beTrue())
                }
                it("should run second block if in same queue") {
                    let inDifferentQueue = queue.sync {
                        queue.ifAtDifferentQueue {
                            false
                        } ifNot: {
                            true
                        }
                    }
                    expect(inDifferentQueue).to(beTrue())
                }
                it("should run safeSync safely") {
                    queue.safeSync {
                        print("this code run safely")
                    }
                }
                it("should run safeSync safely in another same sync") {
                    queue.sync {
                        queue.safeSync {
                            print("this code run safely")
                        }
                    }
                }
                it("should run workitem safeSync safely") {
                    let workItem = DispatchWorkItem { print("this code run safely") }
                    queue.safeSync(execute: workItem)
                }
                it("should run workitem safeSync safely in another same sync") {
                    queue.sync {
                        let workItem = DispatchWorkItem { print("this code run safely") }
                        queue.safeSync(execute: workItem)
                    }
                }
                it("should run aync if in different queue") {
                    var detection: DispatchQueue?
                    waitUntil { done in
                        queue.asyncIfNeeded {
                            detection = DispatchQueue.current
                            done()
                        }
                    }
                    expect(detection).to(equal(queue))
                }
                it("should run workitem aync if in different queue") {
                    var detection: DispatchQueue?
                    waitUntil { done in
                        let workItem = DispatchWorkItem {
                            detection = DispatchQueue.current
                            done()
                        }
                        queue.asyncIfNeeded(execute: workItem)
                    }
                    expect(detection).to(equal(queue))
                }
                it("should run right away if in same queue") {
                    var runRightAway: Bool = false
                    queue.sync {
                        queue.asyncIfNeeded {
                            runRightAway = true
                        }
                    }
                    expect(runRightAway).to(beTrue())
                }
                it("should run workitem right away if in same queue") {
                    var runRightAway: Bool = false
                    queue.sync {
                        let workItem = DispatchWorkItem {
                            runRightAway = true
                        }
                        queue.asyncIfNeeded(execute: workItem)
                    }
                    expect(runRightAway).to(beTrue())
                }
            }
        }
    }
}
