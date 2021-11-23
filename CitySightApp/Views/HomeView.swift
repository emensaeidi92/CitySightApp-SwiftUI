import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: ContentModel
    @State var isShowingMap = false
    @State var selectedBusiness: Business?

    var body: some View {
        if viewModel.resturants.count != 0 || viewModel.sights.count != 0 {
            NavigationView {
                if !isShowingMap {

                    VStack {
                        HStack {
                            Image(systemName: "location")
                            Text("Los Angeles")
                            Spacer()
                            Button {
                                isShowingMap = true
                            } label: {
                                Text("Switch to Map View")
                            }
                        }
                        Divider()
                        BusinessListView()
                    }
                    .padding([.horizontal,.top])
                    .navigationBarHidden(true)
                }
                else {
                    ZStack(alignment: .top) {
                        BusinessMapView(selectedBusiness: $selectedBusiness)
                            .ignoresSafeArea(.all)
                            .sheet(item: $selectedBusiness) { business in
                                BusinessDetailView(business: business)
                            }
                        ZStack {
                            Rectangle()
                                .foregroundColor(.white)
                                .cornerRadius(5)
                                .frame(height: 55)

                            HStack {
                                Image(systemName: "location")
                                Text("Los Angeles")
                                Spacer()
                                Button {
                                    isShowingMap = false
                                } label: {
                                    Text("Switch to List View")
                                }
                            }
                            .padding()
                        }
                        .padding()
                    }
                    .navigationBarHidden(true)
                }
            }

        }
        else {
            ProgressView()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
