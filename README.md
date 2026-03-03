# VetRec Assessment

SwiftUI iOS app for veterinarians to track medication prescriptions and export/share them as PDF.

## Build & Run

**Requirements:** Xcode 16.4+, iOS 18.5+

1. Open `VetRecAssesment.xcodeproj`
2. Select a simulator or device
3. **Cmd + R**


## Architecture & Decisions

**Clean Architecture + MVVM.** Each feature is split into Data (repositories, data sources, mappers), Domain (entities, use cases, protocols), and Presentation (SwiftUI views + ObservableObject view models). The domain layer defines protocols, the data layer implements them. Views depend only on domain, never on data directly.

**Design patterns used:**
- **Repository** — abstracts whether data comes from the simulated remote JSON or CoreData.
- **Mapper** — converts JSON DTOs and CoreData managed objects into clean domain structs.
- **Use Case** — single responsibility classes for each business operation, keeping view models thin.
- **Protocol-oriented DI** — enables swapping implementations for testing.
- **ViewState enum** — generic `loading / loaded / error` for consistent async UI handling.

**Key tradeoffs:**
- Zero third-party libraries — only native Apple frameworks (SwiftUI, CoreData, PhotosUI, UIKit for PDF).
- CoreData stores URL strings and file paths only.
- Simulated remote API via bundled `pets.json`; first-launch sync to CoreData, then offline-only.

**Problems encountered:**
- CoreData auto-generated entity classes return all attributes as optionals, requiring defensive unwrapping throughout mappers.
- The backend is simulated via a local JSON file, so there's no way to test against a real API or handle real network failure scenarios.
- `@MainActor` isolation warnings in view models — an ongoing Swift concurrency issue that hasn't been fully resolved.
- The animals photo API (`animals.maxz.dev`) was proposed for pet images, but finding reliable sources with enough variety of animal photos was difficult.

**AI usage:** Cursor was used as pair-programming assistant, helping plan the architecture, scaffold boilerplate (CoreData, mappers, PDF generation), iterate on UI and debug issues. All output was supervised and verified by me, including manualy fixing bugs the AI introduced and writing code by hand when needed. Architectural decisions were entirely driven by me.
