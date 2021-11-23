import SwiftUI

struct BusinessRowView: View {
    var businesses: Business

    var body: some View {

        VStack(alignment: .leading) {

            HStack {
                BusinessRemoteImage(urlString: businesses.image_url ?? "")
                    .frame(width: 58, height: 58)
                    .scaledToFit()
                    .cornerRadius(5)

                VStack(alignment: .leading) {
                    Text(businesses.name ?? "")
                        .bold()
                    Text(String(format: "%.1f Miles away", (businesses.distance ?? 0) * 0.000621371))
                        .font(.caption)
                }
                Spacer()

                VStack(alignment: .leading) {
                    Image("regular_\(businesses.rating ?? 0)")
                    Text("\(businesses.review_count ?? 0) Reviews")
                        .font(.caption)
                }
            }

            Divider()
        }
        .foregroundColor(.black)

    }
}


