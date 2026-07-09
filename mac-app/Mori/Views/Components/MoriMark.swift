import SwiftUI

/// The little forest-guardian mark, drawn with shapes so it scales crisply.
/// A moss seed body, a leaf-horn crown and two calm eyes.
struct MoriMark: View {
    var size: CGFloat = 24

    var body: some View {
        Canvas { ctx, rect in
            let s = min(rect.width, rect.height)
            func p(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
                CGPoint(x: x / 100 * s, y: y / 100 * s)
            }

            // sprout stem
            var stem = Path()
            stem.move(to: p(50, 22))
            stem.addLine(to: p(50, 12))
            ctx.stroke(stem, with: .color(Theme.forest), lineWidth: s * 0.03)

            // leaf-horn ears
            var ears = Path()
            ears.move(to: p(39, 24))
            ears.addCurve(to: p(45, 24), control1: p(30, 8), control2: p(38, 6))
            ears.closeSubpath()
            ears.move(to: p(61, 24))
            ears.addCurve(to: p(55, 24), control1: p(70, 8), control2: p(62, 6))
            ears.closeSubpath()
            ctx.fill(ears, with: .color(Theme.moss))

            // body
            var body = Path()
            body.addEllipse(in: CGRect(x: p(18, 22).x, y: p(18, 22).y,
                                       width: (82 - 18) / 100 * s, height: (87 - 22) / 100 * s))
            ctx.fill(body, with: .color(Theme.forest))

            // belly
            var belly = Path()
            belly.addEllipse(in: CGRect(x: p(31, 40).x, y: p(31, 40).y,
                                        width: (69 - 31) / 100 * s, height: (85 - 40) / 100 * s))
            ctx.fill(belly, with: .color(Theme.softGreen.opacity(0.85)))

            // eyes
            let eyeW = s * 0.09
            for cx in [CGFloat(40), CGFloat(60)] {
                var eye = Path()
                eye.addEllipse(in: CGRect(x: p(cx, 52).x - eyeW / 2, y: p(cx, 52).y - eyeW / 2,
                                          width: eyeW, height: eyeW * 1.1))
                ctx.fill(eye, with: .color(Theme.ink))
            }
        }
        .frame(width: size, height: size)
        .accessibilityHidden(true)
    }
}
