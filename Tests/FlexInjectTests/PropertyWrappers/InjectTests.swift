//
//  InjectTests.swift
//  
//
//  Created by Daniel Carmo on 2022-08-11.
//

import Foundation
import Nimble
import Quick

@testable import FlexInject

private let InjectedClass1ValueProperty = "InjectedClass1ValueProperty"
private let InjectedClass2ValueProperty = "InjectedClass2ValueProperty"

private protocol InjectedClassProtocol {
  var value: String { get }
}

private class InjectedClass1: InjectedClassProtocol {
  var value: String = InjectedClass1ValueProperty
}

private class InjectedClass2: InjectedClassProtocol {
  var value: String = InjectedClass2ValueProperty
}

class InjectTests: QuickSpec {
  
  override func spec() {
    
    // MARK: - Properties
    
    // MARK: - Mocks
    
    // MARK: - Mock Objects
    
    // MARK: - System Under Test
    
    var sut: Inject<InjectedClassProtocol>!
    
    // MARK: - Tests
    
    describe("Inject propertyWrapper") {
      
      beforeEach {
        DependencyContainer.shared.removeAll()
        DependencyContainer.shared.register(type: InjectedClassProtocol.self) {
          InjectedClass1()
        }
      }
      
      context("When using the default arguments") {
      
        beforeEach {
          sut = Inject()
        }
          
        it("Should set the wrapped value to the InjectedClass") {
          expect(sut.wrappedValue.value).to(equal(InjectedClass1ValueProperty))
        }
      }
      
      context("When using a custom container") {
        
        let customContainer: DIContainer = DependencyContainer()
        
        beforeEach {
          customContainer.register(type: InjectedClassProtocol.self) {
            InjectedClass2()
          }
        }
        
        it("Should resolve the dependency from the custom container and not the shared") {
          sut = Inject(container: customContainer)
          expect(sut.wrappedValue.value).to(equal(InjectedClass2ValueProperty))
        }
      }
      
      context("When using a key") {
        
        let testDependencyKey = "key"
        
        beforeEach {
          DependencyContainer.shared.register(key: testDependencyKey) {
            InjectedClass2()
          }
        }
        
        it("Should resolve the dependency from the custom container and not the shared") {
          sut = Inject(key: testDependencyKey)
          expect(sut.wrappedValue.value).to(equal(InjectedClass2ValueProperty))
        }
      }
      
      context("When using mode .shared") {
        
        it("Should resolve the dependency with the same address always") {
          sut = Inject(mode: .shared)
          
          let resolved1 = sut.wrappedValue
          let resolved2 = sut.wrappedValue
          
          let resolved1Address = Unmanaged.passUnretained(resolved1 as AnyObject).toOpaque()
          let resolved2Address = Unmanaged.passUnretained(resolved2 as AnyObject).toOpaque()
          
          expect(resolved1Address).to(equal(resolved2Address))
        }
      }
      
      context("When using mode .new") {
        
        it("Should resolve the dependency with different addresses always") {
          sut = Inject(mode: .new)
          let sut2: Inject<InjectedClassProtocol>! = Inject(mode: .new)
          
          let resolved1 = sut.wrappedValue
          let resolved2 = sut2.wrappedValue
          
          let resolved1Address = Unmanaged.passUnretained(resolved1 as AnyObject).toOpaque()
          let resolved2Address = Unmanaged.passUnretained(resolved2 as AnyObject).toOpaque()
          
          expect(resolved1Address).toNot(equal(resolved2Address))
        }
      }
      
    }
  }
}
