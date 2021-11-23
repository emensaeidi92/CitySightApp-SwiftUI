import SwiftUI

struct BusinessTitle: View {

    var business: Business

    var body: some View {

        VStack (alignment: .leading) {
            Text(business.name!)
                .font(.largeTitle)
                .padding()

            if business.location?.display_address != nil {

                ForEach(business.location!.display_address!, id:\.self) { displayLine in
                    Text(displayLine)
                        .padding(.horizontal)
                }
            }

            Image("regular_\(business.rating ?? 0)")
                .padding()
        }
    }
}

