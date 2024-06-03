import SwiftUI

struct LabelStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(.title, design: .rounded, weight: .ultraLight))
    }
}

struct ButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 60, weight: .ultraLight, design: .rounded))
    }
}

struct TimeStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("HelveticaNeue-Thin", size: 80)).monospacedDigit()
    }
}

extension View {
    func labelStyle() -> some View {
        self.modifier(LabelStyle())
    }
    func buttonStyle() -> some View {
        self.modifier(ButtonStyle())
    }
    func timeStyle() -> some View {
        self.modifier(TimeStyle())
    }
}
