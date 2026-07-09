import AppKit

/// Draws the Mori guardian as a template menu-bar image (auto light/dark).
/// A rounded seed body + two leaf-horn ears + two knocked-out eyes.
enum MenuBarIcon {
    static let normal: NSImage = make(paused: false)
    static let paused: NSImage = make(paused: true)

    static func image(paused: Bool) -> NSImage {
        paused ? self.paused : self.normal
    }

    private static func make(paused: Bool) -> NSImage {
        let size = NSSize(width: 18, height: 18)
        let image = NSImage(size: size, flipped: false) { rect in
            let s = min(rect.width, rect.height)

            NSColor.black.setFill()
            NSColor.black.setStroke()

            // body (bottom-weighted rounded seed)
            let body = NSBezierPath(
                roundedRect: NSRect(x: 0.16 * s, y: 0.05 * s, width: 0.68 * s, height: 0.66 * s),
                xRadius: 0.30 * s, yRadius: 0.30 * s
            )

            // two leaf-horn ears
            let ears = NSBezierPath()
            for dx in [CGFloat(-0.14), CGFloat(0.14)] {
                let cx = 0.5 * s + dx * s
                ears.move(to: NSPoint(x: cx - 0.05 * s, y: 0.62 * s))
                ears.line(to: NSPoint(x: cx, y: 0.96 * s))
                ears.line(to: NSPoint(x: cx + 0.05 * s, y: 0.62 * s))
                ears.close()
            }

            if paused {
                // resting: outline only
                body.lineWidth = 1.2
                body.stroke()
                ears.lineWidth = 1.2
                ears.stroke()
            } else {
                body.fill()
                ears.fill()

                // knock out the eyes
                NSGraphicsContext.current?.compositingOperation = .destinationOut
                for dx in [CGFloat(-0.13), CGFloat(0.13)] {
                    let cx = 0.5 * s + dx * s
                    NSBezierPath(ovalIn: NSRect(
                        x: cx - 0.075 * s, y: 0.30 * s, width: 0.15 * s, height: 0.17 * s
                    )).fill()
                }
                NSGraphicsContext.current?.compositingOperation = .sourceOver
            }

            return true
        }
        image.isTemplate = true
        return image
    }
}
