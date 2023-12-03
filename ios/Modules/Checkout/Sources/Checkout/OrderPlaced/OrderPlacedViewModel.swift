import Combine
import Foundation

protocol OrderPlacedPresenting {
    func displayDeliveryDate(_ date: Date)
}

class OrderPlacedViewModel: ObservableObject, OrderPlacedPresenting {
    private let dateFormatter = RelativeDateTimeFormatter()
    private var cancellables = Set<AnyCancellable>()

    @Published
    var timeToDeliver: String = ""
    
    func displayDeliveryDate(_ date: Date) {
        cancellables.removeAll()
        
        updateTimeToDeliver(currentDate: Date(), targetDate: date)
        Timer.publish(every: 1, on: .main, in: .common).autoconnect().sink { [unowned self] currentDate in
            updateTimeToDeliver(currentDate: currentDate, targetDate: date)
        }.store(in: &cancellables)
    }
    
    private func updateTimeToDeliver(currentDate: Date, targetDate: Date) {
        guard currentDate.distance(to: targetDate) > 0 else {
            cancellables.removeAll()
            timeToDeliver = "a qualquer momento"
            return
        }
        timeToDeliver = dateFormatter.localizedString(for: targetDate, relativeTo: currentDate)
    }
}
