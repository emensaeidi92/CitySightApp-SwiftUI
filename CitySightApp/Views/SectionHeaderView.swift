import SwiftUI

struct SectionHeaderView: View {
    var title: String
    var body: some View {
        ZStack(alignment:.leading) {
            Rectangle()
                .foregroundColor(.white)
            Text(title)
                .font(.headline)
        }
    }
}

struct SectionHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        SectionHeaderView(title: "Sights")
    }
}
