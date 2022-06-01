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
        var atomicText: Atomic<String>!
        beforeEach {
            atomicText = Atomic(wrappedValue: "atomicText")
        }
        it("should assign the value atomically") {
            atomicText.wrappedValue = "main"
            DispatchQueue.global(qos: .utility).async {
                atomicText.wrappedValue = "background"
            }
            // this sometimes fail because its already changed to background
//            expect(atomicText.wrappedValue).toEventually(equal("main"))
            expect(atomicText.wrappedValue).toEventually(equal("background"))
        }
    }
}
