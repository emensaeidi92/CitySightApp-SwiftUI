import SwiftUI

struct BusinessListView: View {
    @EnvironmentObject var viewModel: ContentModel

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, pinnedViews: [.sectionHeaders]) {

                Section(header: SectionHeaderView(title: "Restaurants")) {
                    ForEach(viewModel.resturants) { business in
                        NavigationLink(destination: BusinessDetailView(business: business)) {
                            BusinessRowView(businesses: business)
                        }
                    }
                }

                Section(header: SectionHeaderView(title: "Sights")){
                    ForEach(viewModel.sights) { business in
                        BusinessRowView(businesses: business )
                    }
                }
            }
        }
    }
}
struct BusinessListView_Previews: PreviewProvider {
    static var previews: some View {
        BusinessListView()
    }
}
