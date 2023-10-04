import SwiftUI

@available(iOS 15.0, *)
public enum CoreImage: View, Hashable {
    case image(Image)
    case url(URL)
    case system(String)
    
    public var body: some View {
        switch self {
        case .image(let image):
            image
                .resizable()
        case .url(let url):
            AsyncImage(url: url) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }

        case .system(let systemName):
            Image(systemName: systemName)
                .resizable()
        }
    }
    
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .image(let image):
            hasher.combine(String(describing: image))
        case .url(let url):
            hasher.combine(url)
        case .system(let systemName):
            hasher.combine(systemName)
        }
    }
}
