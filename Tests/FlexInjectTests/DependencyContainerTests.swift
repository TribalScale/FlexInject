import Nimble
import Quick

@testable import FlexInject

private protocol DependencyTestProtocol: AnyObject { }
private class DependencyTest: DependencyTestProtocol { }

class DependencyContainerTests: QuickSpec {
  
  override func spec() {
    
    // MARK: - Properties
    
    // MARK: - Mocks
    
    // MARK: - Mock Objects
    
    // MARK: - System Under Test
    
    var sut: DependencyContainer!
    
    // MARK: - Tests
    
    describe("Dependency Container") {
      
      beforeEach {
        sut = DependencyContainer()
      }
      
      // MARK: - Register Tests
      
      context("When registering a dependency by type") {
        it("Should be resolvable by the type") {
          sut.register(type: DependencyTestProtocol.self) { DependencyTest() }
          
          let resolved = sut.resolve(type: DependencyTestProtocol.self, mode: .shared)
          
          expect(resolved).toNot(beNil())
        }
      }
      
      context("When registering a dependency by key") {
        it("Should be resolvable by the type") {
          sut.register(key: "Dependency") { DependencyTest() }
          
          let resolved: DependencyTestProtocol = sut.resolve(key: "Dependency", mode: .shared)
          
          expect(resolved).toNot(beNil())
        }
      }
      
      // MARK: - ResolveMode Tests
      
      context("when the resolve mode is shared") {
        it("Should return the same dependency object") {
          sut.register(type: DependencyTestProtocol.self) { DependencyTest() }
          
          let resolved1 = sut.resolve(type: DependencyTestProtocol.self, mode: .shared)
          let resolved2 = sut.resolve(type: DependencyTestProtocol.self, mode: .shared)
          
          let resolved1Address = Unmanaged.passUnretained(resolved1 as AnyObject).toOpaque()
          let resolved2Address = Unmanaged.passUnretained(resolved2 as AnyObject).toOpaque()
          
          expect(resolved1Address).to(equal(resolved2Address))
        }
      }
      
      context("when the resolve mode is new") {
        it("Should return the a new dependency object") {
          sut.register(type: DependencyTestProtocol.self) { DependencyTest() }
          
          let resolved1 = sut.resolve(type: DependencyTestProtocol.self, mode: .new)
          let resolved2 = sut.resolve(type: DependencyTestProtocol.self, mode: .new)
          
          let resolved1Address = Unmanaged.passUnretained(resolved1 as AnyObject).toOpaque()
          let resolved2Address = Unmanaged.passUnretained(resolved2 as AnyObject).toOpaque()
          
          expect(resolved1Address).toNot(equal(resolved2Address))
        }
      }
      
      // MARK: - Resolve missing dependencies Tests
      
      context("When a dependency hasn't been registered for a type") {
        it("Should crash the app") {
          expect { sut.resolve(type: DependencyTestProtocol.self, mode: .shared) }.to(throwAssertion())
        }
      }
      
      context("When a dependency hasn't been registered for a key") {
        it("Should crash the app") {
          expect { sut.resolve(key: "Dependency", mode: .shared) }.to(throwAssertion())
        }
      }
    }
  }
}
