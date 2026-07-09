// Renders the Mori app icon (a faithful copy of the landing page's app/icon.svg:
// a forest-gradient rounded tile + the cream guardian) to PNGs at every size.
//
// Usage:  swift Tools/MakeAppIcon.swift <output-dir>
// Writes: <output-dir>/{16,32,64,128,256,512,1024}.png
import AppKit
import Foundation

func color(_ hex: UInt32) -> NSColor {
    NSColor(srgbRed: CGFloat((hex >> 16) & 0xFF) / 255,
            green: CGFloat((hex >> 8) & 0xFF) / 255,
            blue: CGFloat(hex & 0xFF) / 255,
            alpha: 1)
}

let cream = color(0xF4EDDA)
let eyeFill = color(0x3A5A43)
let pupil = color(0x1B2A20)
let nose = color(0xB9A784)
let gradTop = color(0x3A5A43)
let gradBottom = color(0x233A2B)

func render(_ size: Int) -> Data {
    let s = CGFloat(size)
    let f = s / 100.0
    func p(_ x: CGFloat, _ y: CGFloat) -> NSPoint { NSPoint(x: x * f, y: (100 - y) * f) }
    func oval(_ cx: CGFloat, _ cy: CGFloat, _ rx: CGFloat, _ ry: CGFloat) -> NSRect {
        NSRect(x: (cx - rx) * f, y: (100 - (cy + ry)) * f, width: 2 * rx * f, height: 2 * ry * f)
    }

    let rep = NSBitmapImageRep(
        bitmapDataPlanes: nil, pixelsWide: size, pixelsHigh: size,
        bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false,
        colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0
    )!
    rep.size = NSSize(width: s, height: s)

    NSGraphicsContext.saveGraphicsState()
    let ctx = NSGraphicsContext(bitmapImageRep: rep)!
    NSGraphicsContext.current = ctx
    ctx.shouldAntialias = true

    // rounded tile with a soft top→bottom forest gradient
    let tile = NSBezierPath(roundedRect: NSRect(x: 0, y: 0, width: s, height: s),
                            xRadius: 23 * f, yRadius: 23 * f)
    if let grad = NSGradient(starting: gradTop, ending: gradBottom) {
        grad.draw(in: tile, angle: -90)
    } else {
        gradTop.setFill(); tile.fill()
    }

    // cream guardian (stem, two sprout leaves, two ears, body)
    cream.setFill()

    let stem = NSBezierPath(roundedRect: NSRect(x: 48.8 * f, y: (100 - 23) * f, width: 2.4 * f, height: 11 * f),
                            xRadius: 1.2 * f, yRadius: 1.2 * f)
    stem.fill()

    let sproutL = NSBezierPath()
    sproutL.move(to: p(50, 8))
    sproutL.curve(to: p(43, 18), controlPoint1: p(44, 9), controlPoint2: p(41, 13))
    sproutL.curve(to: p(50, 8), controlPoint1: p(48, 17), controlPoint2: p(51, 13))
    sproutL.close(); sproutL.fill()

    let sproutR = NSBezierPath()
    sproutR.move(to: p(50, 8))
    sproutR.curve(to: p(57, 18), controlPoint1: p(56, 9), controlPoint2: p(59, 13))
    sproutR.curve(to: p(50, 8), controlPoint1: p(52, 17), controlPoint2: p(49, 13))
    sproutR.close(); sproutR.fill()

    let earL = NSBezierPath()
    earL.move(to: p(39, 24))
    earL.curve(to: p(30, 1), controlPoint1: p(31, 13), controlPoint2: p(26, 5))
    earL.curve(to: p(45, 24), controlPoint1: p(38, 5), controlPoint2: p(46, 15))
    earL.close(); earL.fill()

    let earR = NSBezierPath()
    earR.move(to: p(61, 24))
    earR.curve(to: p(70, 1), controlPoint1: p(69, 13), controlPoint2: p(74, 5))
    earR.curve(to: p(55, 24), controlPoint1: p(62, 5), controlPoint2: p(54, 15))
    earR.close(); earR.fill()

    let body = NSBezierPath()
    body.move(to: p(50, 22))
    body.curve(to: p(84, 55), controlPoint1: p(71, 22), controlPoint2: p(84, 36))
    body.curve(to: p(50, 87), controlPoint1: p(84, 74), controlPoint2: p(71, 87))
    body.curve(to: p(16, 55), controlPoint1: p(29, 87), controlPoint2: p(16, 74))
    body.curve(to: p(50, 22), controlPoint1: p(16, 36), controlPoint2: p(29, 22))
    body.close(); body.fill()

    // eyes (tile colour), pupils, catch-lights, nose
    eyeFill.setFill()
    NSBezierPath(ovalIn: oval(38, 53, 8, 9)).fill()
    NSBezierPath(ovalIn: oval(62, 53, 8, 9)).fill()

    pupil.setFill()
    NSBezierPath(ovalIn: oval(38, 55, 5.5, 5.5)).fill()
    NSBezierPath(ovalIn: oval(62, 55, 5.5, 5.5)).fill()

    cream.setFill()
    NSBezierPath(ovalIn: oval(40.5, 50.5, 2.2, 2.2)).fill()
    NSBezierPath(ovalIn: oval(64.5, 50.5, 2.2, 2.2)).fill()

    nose.setFill()
    NSBezierPath(ovalIn: oval(50, 68, 2.4, 1.9)).fill()

    NSGraphicsContext.restoreGraphicsState()
    return rep.representation(using: .png, properties: [:])!
}

let outDir = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "."
for size in [16, 32, 64, 128, 256, 512, 1024] {
    let data = render(size)
    let url = URL(fileURLWithPath: outDir).appendingPathComponent("\(size).png")
    try! data.write(to: url)
    FileHandle.standardError.write("rendered \(size)px\n".data(using: .utf8)!)
}
