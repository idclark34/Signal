# Signal

A macOS menubar app that gently displays motivational reminders throughout your day. Designed to reinforce purpose and long-term thinking with minimal interruption.

## Philosophy

Signal is built on a few core beliefs:

- **Calm > hype** — No flashy notifications or urgent vibes
- **Identity > metrics** — Reinforce who you're becoming, not what you're tracking
- **Scarcity > frequency** — A few meaningful moments beat constant noise
- **Motion as presence** — Subtle animations that feel alive, not distracting

## Features

### Minimal Popup Design
- Floating text and graphics with no background box
- Readable on any desktop background with subtle text shadows
- Auto-dismisses after 4 seconds
- Click anywhere to dismiss, or press ESC

### Three Animation Styles
- **Progress Line** — A thin line draws left to right, symbolizing continuation
- **Horizon** — A soft line with drifting light, representing long-term direction
- **Moving Dot** — A dot travels along a path, step-by-step progress

### Three Exit Animations
Each popup randomly selects one of three exit styles:
- **Flip up** — Text rotates backward and away
- **Shrink inward** — Text scales down to center
- **Slide down** — Text drops with a subtle blur

### Configurable Schedule
- **Frequency options**: Every 30 minutes, hourly, every 2 hours, every 4 hours, or once daily
- **Active hours**: Set a time window (e.g., 9 AM – 6 PM) when reminders can appear
- Reminders only show during your active hours

### Messages
Curated, grounded messages designed to reinforce calm persistence:

> "You are building something that compounds quietly."

> "Nothing is wrong. Continue."

> "Today matters more than it feels."

> "The obstacle is the material."

Messages don't repeat within 7 days.

## Requirements

- macOS 13.0 or later
- Xcode 15.0 or later (to build)

## Installation

### Build from Source

1. Clone the repository:
   ```bash
   git clone https://github.com/idclark34/Signal.git
   cd Signal
   ```

2. Open in Xcode:
   ```bash
   open QuietBuild.xcodeproj
   ```

3. Build and run (⌘R)

The app will appear as a leaf icon in your menubar.

## Usage

### Menubar Menu
- **Show Reminder** — Manually trigger a popup
- **Settings** — Configure frequency, active hours, and animation style
- **Quit** — Close the app

### Settings
| Option | Description |
|--------|-------------|
| Enable reminders | Toggle automatic popups on/off |
| Frequency | How often reminders appear |
| Active hours | Time window for reminders |
| Enable animations | Toggle graphic animations |
| Graphic style | Choose Random, Progress Line, Horizon, or Moving Dot |

## Project Structure

```
QuietBuild/
├── QuietBuildApp.swift      # App entry, menubar setup
├── Info.plist               # App config (menubar-only via LSUIElement)
│
├── Models/
│   ├── Message.swift        # Message data model
│   └── AppSettings.swift    # User preferences (UserDefaults)
│
├── Views/
│   ├── PopupView.swift      # Main popup UI and animations
│   ├── SettingsView.swift   # Preferences window
│   └── SavedThoughtsView.swift
│
├── Graphics/
│   ├── ProgressLineView.swift   # Line drawing animation
│   ├── HorizonView.swift        # Drifting light animation
│   └── MovingDotView.swift      # Traveling dot animation
│
├── Services/
│   ├── PopupScheduler.swift     # Timing and trigger logic
│   ├── MessageStore.swift       # Message selection, no-repeat logic
│   └── SavedMessagesStore.swift
│
└── Utilities/
    └── Constants.swift      # Messages array, dimensions, timing
```

## Technical Notes

- **Menubar-only**: Uses `LSUIElement = true` so no dock icon appears
- **Non-intrusive**: Popup uses `NSPanel` with `.nonactivatingPanel` style — won't steal focus from your current app
- **Lightweight**: No background polling loops, minimal CPU usage
- **Local-only**: All data stored in UserDefaults, no network calls

## Customization

### Adding Messages
Edit `QuietBuild/Utilities/Constants.swift`:

```swift
static let messages: [String] = [
    "Your message here.",
    // ...
]
```

### Adjusting Timing
In `Constants.swift`:
```swift
static let autoDismissDelay: TimeInterval = 4.0  // Popup duration
```

## License

MIT

## Acknowledgments

Built with SwiftUI for macOS. Inspired by the idea that productivity isn't about doing more — it's about reducing friction between intention and action.
