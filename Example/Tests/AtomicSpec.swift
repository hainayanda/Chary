//
//  AtomicSpec.swift
//  Chary_Tests
//
//  Created by Nayanda Haberty on 01/06/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Chary

class AtomicSpec: QuickSpec {
    
    override func spec() {
        var atomicCount: Atomic<Int>!
        beforeEach {
            atomicCount = Atomic(wrappedValue: 0)
        }
        it("should assign the value atomically") {
            DispatchQueue.main.async {
                print("main executed")
                atomicCount.wrappedValue += 1
            }
            DispatchQueue.global(qos: .background).async {
                print("background executed")
                atomicCount.wrappedValue += 1
            }
            expect(atomicCount.wrappedValue).toEventually(equal(2))
        }
    }
}
