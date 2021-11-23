import SwiftUI

struct BusinessDetailView: View {
    var business: Business
    @State private var isPresented = false
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment:.leading, spacing:0) {
                BusinessRemoteImage(urlString: business.image_url ?? "")
                    .clipped()

                ZStack(alignment:.leading) {
                    Rectangle()
                        .frame(height: 36)
                        .foregroundColor(business.is_closed! ? .gray : .blue)
                    Text(String(business.is_closed! ? "Close" : "Open"))
                        .foregroundColor(.white)
                        .bold()
                        .padding(.leading)
                }
            }

            Group {

                BusinessTitle(business: business)

                Divider()

                HStack {
                    Text("Phone:")
                    Text(business.display_phone ?? "")
                    Spacer()
                    Link("Call", destination: URL(string: business.phone ?? "")!)
                }
                .padding()

                Divider()

                HStack {
                    Text("Reviews:")
                    Text(String(business.review_count ?? 0))
                    Spacer()
                    Link("Read", destination: URL(string: business.url ?? "")!)
                }
                .padding()

                Divider()

                HStack {
                    Text("Website:")
                    Text(business.url ?? "")
                        .lineLimit(1)
                    Spacer()
                    Link("Visit", destination: URL(string: business.url ?? "")!)
                }
                .padding()

                Divider()
            }

            Button {
                isPresented = true
            } label: {
                ZStack {
                    Rectangle()
                        .frame(height: 48)
                        .foregroundColor(.blue)
                        .cornerRadius(10)
                    Text("Get Directions")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                }
            }
            .padding()
            .sheet(isPresented: $isPresented){
                DirectionsView(business: business)
            }
        }
        .ignoresSafeArea(.all, edges: .top)
    }
}

