import SwiftUI

@main
struct CitySightApp: App {
    var body: some Scene {
        WindowGroup {
            LunchView()
                .environmentObject(ContentModel())
        }
    }
}
