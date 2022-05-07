import SwiftUI

public struct VisualEffectBlur<Content: View>: View {
    private var blurStyle: UIBlurEffect.Style

    private var vibrancyStyle: UIVibrancyEffectStyle?

    private var content: Content

    public init(blurStyle: UIBlurEffect.Style = .systemMaterial, vibrancyStyle: UIVibrancyEffectStyle? = nil, @ViewBuilder content: () -> Content) {
        self.blurStyle = blurStyle
        self.vibrancyStyle = vibrancyStyle
        self.content = content()
    }

    public var body: some View {
        Representable(blurStyle: blurStyle, vibrancyStyle: vibrancyStyle, content: ZStack { content })
            .accessibility(hidden: Content.self == EmptyView.self)
        .eraseToAnyView()
    }

    #if DEBUG
    @ObservedObject var iO = injectionObserver
    #endif
}

// MARK: - Representable
fileprivate extension VisualEffectBlur {
    struct Representable<Content: View>: UIViewRepresentable {
        var blurStyle: UIBlurEffect.Style
        var vibrancyStyle: UIVibrancyEffectStyle?
        var content: Content

        func makeUIView(context: Context) -> UIVisualEffectView {
            context.coordinator.blurView
        }

        func updateUIView(_ view: UIVisualEffectView, context: Context) {
            context.coordinator.update(content: content, blurStyle: blurStyle, vibrancyStyle: vibrancyStyle)
        }

        func makeCoordinator() -> Coordinator {
            Coordinator(content: content)
        }
    }
}

// MARK: - Coordinator
fileprivate extension VisualEffectBlur.Representable {
    class Coordinator {
        let blurView = UIVisualEffectView()
        let vibrancyView = UIVisualEffectView()
        let hostingController: UIHostingController<Content>

        init(content: Content) {
            hostingController = UIHostingController(rootView: content)
            hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            hostingController.view.backgroundColor = nil
            blurView.contentView.addSubview(vibrancyView)
            
            blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            vibrancyView.contentView.addSubview(hostingController.view)
            vibrancyView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }

        func update(content: Content, blurStyle: UIBlurEffect.Style, vibrancyStyle: UIVibrancyEffectStyle?) {
            hostingController.rootView = content

            let blurEffect = UIBlurEffect(style: blurStyle)
            blurView.effect = blurEffect

            if let vibrancyStyle = vibrancyStyle {
                vibrancyView.effect = UIVibrancyEffect(blurEffect: blurEffect, style: vibrancyStyle)
            } else {
                vibrancyView.effect = nil
            }

            hostingController.view.setNeedsDisplay()
        }
    }
}

public extension VisualEffectBlur where Content == EmptyView {
    init(blurStyle: UIBlurEffect.Style = .systemMaterial) {
        self.init(blurStyle: blurStyle, vibrancyStyle: nil) {
            EmptyView()
        }
    }
}

struct BackgroundBlur: ViewModifier {
    let blurStyle: UIBlurEffect.Style
    let vibrancyStyle: UIVibrancyEffectStyle?
    
    init(blur: UIBlurEffect.Style, vibrancy: UIVibrancyEffectStyle?) {
        self.blurStyle = blur
        self.vibrancyStyle = vibrancy
    }
    
    func body(content: Content) -> some View {
        content
            .background(VisualEffectBlur(blurStyle: blurStyle, vibrancyStyle: vibrancyStyle, content: { EmptyView() }))
        .eraseToAnyView()
    }

    #if DEBUG
    @ObservedObject var iO = injectionObserver
    #endif
}

public extension View {
    func backgroundBlur(_ blurStyle: UIBlurEffect.Style = .systemMaterial, vibrancy vibrancyStyle: UIVibrancyEffectStyle? = nil) -> some View {
        return modifier(BackgroundBlur(blur: blurStyle, vibrancy: vibrancyStyle))
    }
}

struct VisualEffects_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello, world!")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                VisualEffectBlur(blurStyle: .systemMaterial)
            )
    }
}
