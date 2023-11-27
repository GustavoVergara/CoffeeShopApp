import Combine

public protocol Streaming {
    associatedtype Output
    associatedtype Streamer: Publisher<Output, Never>
    func publisher() -> Streamer
}

public protocol MutableStreaming: Streaming {
    func emit(_ data: Output)
}

final class Stream<Output>: MutableStreaming {
    @Published
    var output: Output?

    func publisher() -> some Publisher<Output, Never> {
        $output.compactMap { $0 }
    }
    
    func emit(_ output: Output) {
        self.output = output
    }
}
