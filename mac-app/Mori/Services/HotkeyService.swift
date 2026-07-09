import AppKit
import Carbon.HIToolbox

/// Registers global hotkeys using the Carbon Hot Key API — the reliable,
/// low-overhead way to catch shortcuts system-wide. Supports multiple hotkeys,
/// each routed to its own handler by id.
final class HotkeyService {
    static let shared = HotkeyService()

    /// Hotkey ids used by the app.
    enum ID: UInt32 {
        case quickAction = 1   // ⌥M
        case composer = 2      // ⌥⇧M
    }

    private var refs: [UInt32: EventHotKeyRef] = [:]
    private var handlers: [UInt32: () -> Void] = [:]
    private var eventHandler: EventHandlerRef?
    private let signature = OSType(0x4D4F5249) // 'MORI'

    private init() {}

    /// Install the shared Carbon event handler once.
    func start() {
        guard eventHandler == nil else { return }
        var eventType = EventTypeSpec(
            eventClass: OSType(kEventClassKeyboard),
            eventKind: UInt32(kEventHotKeyPressed)
        )
        InstallEventHandler(
            GetApplicationEventTarget(),
            { _, event, _ -> OSStatus in
                guard let event else { return noErr }
                var hkID = EventHotKeyID()
                let status = GetEventParameter(
                    event,
                    EventParamName(kEventParamDirectObject),
                    EventParamType(typeEventHotKeyID),
                    nil,
                    MemoryLayout<EventHotKeyID>.size,
                    nil,
                    &hkID
                )
                if status == noErr {
                    let id = hkID.id
                    DispatchQueue.main.async {
                        HotkeyService.shared.handlers[id]?()
                    }
                }
                return noErr
            },
            1,
            &eventType,
            nil,
            &eventHandler
        )
    }

    /// Register (or replace) a hotkey.
    func register(_ id: ID, keyCode: UInt32, modifiers: UInt32, handler: @escaping () -> Void) {
        start()
        unregister(id)
        handlers[id.rawValue] = handler

        let hotKeyID = EventHotKeyID(signature: signature, id: id.rawValue)
        var ref: EventHotKeyRef?
        let status = RegisterEventHotKey(
            keyCode,
            modifiers,
            hotKeyID,
            GetApplicationEventTarget(),
            0,
            &ref
        )
        if status == noErr, let ref {
            refs[id.rawValue] = ref
        }
    }

    func unregister(_ id: ID) {
        if let ref = refs[id.rawValue] {
            UnregisterEventHotKey(ref)
            refs[id.rawValue] = nil
        }
        handlers[id.rawValue] = nil
    }

    func unregisterAll() {
        for ref in refs.values { UnregisterEventHotKey(ref) }
        refs.removeAll()
        handlers.removeAll()
        if let eventHandler {
            RemoveEventHandler(eventHandler)
            self.eventHandler = nil
        }
    }
}
