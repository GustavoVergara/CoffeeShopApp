import SwiftUI

public struct AsyncButton<Label: View>: View {
    var actionOptions = Set(ActionOption.allCases)
    var action: () async -> Void
    @ViewBuilder var label: () -> Label
    
    public init(actionOptions: Set<ActionOption> = Set(ActionOption.allCases), action: @escaping () async -> Void, label: @escaping () -> Label) {
        self.action = action
        self.actionOptions = actionOptions
        self.label = label
    }

    @State private var isDisabled = false
    @State private var showProgressView = false

    public var body: some View {
        Button(
            action: {
                if actionOptions.contains(.disableButton) {
                    isDisabled = true
                }
            
                Task {
                    var progressViewTask: Task<Void, Error>?

                    if actionOptions.contains(.showProgressView) {
                        progressViewTask = Task {
                            try await Task.sleep(nanoseconds: 150_000_000)
                            showProgressView = true
                        }
                    }

                    await action()
                    progressViewTask?.cancel()

                    isDisabled = false
                    showProgressView = false
                }
            },
            label: {
                ZStack {
                    label().opacity(showProgressView ? 0 : 1)

                    if showProgressView {
                        ProgressView()
                    }
                }
            }
        )
        .disabled(isDisabled)
    }
}

public extension AsyncButton {
    enum ActionOption: CaseIterable {
        case disableButton
        case showProgressView
    }
}
