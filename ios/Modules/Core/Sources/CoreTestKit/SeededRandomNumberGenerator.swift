import GameplayKit

public struct SeededRandomNumberGenerator: RandomNumberGenerator {
    private let generator: GKMersenneTwisterRandomSource
    
    public init(_ seed: UInt64) {
        generator = GKMersenneTwisterRandomSource(seed: seed)
    }
    
    public func next() -> UInt64 {
        UInt64(abs(generator.nextInt()))
    }
}
