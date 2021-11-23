import SwiftUI
import CoreLocation

struct LunchView: View {
    @EnvironmentObject var viewModel: ContentModel
    
    var body: some View {
        if viewModel.authorizationState == .authorizedAlways || viewModel.authorizationState == .authorizedWhenInUse {
            HomeView()
        } else {
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LunchView()
    }
}
