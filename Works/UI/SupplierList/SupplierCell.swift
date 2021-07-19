import SwiftUI

struct SupplierCell: View {
    let supplier: Supplier
    let action: () -> Void

    var body: some View {
        Button(action: {
            action()
        }) {
            HStack {
                Image(systemName: "building.2.fill")
                    .resizable()
                    .foregroundColor(.gray)
                    .frame(width: 80, height: 80)

                VStack(alignment: .leading) {
                    Text(supplier.name)
                        .foregroundColor(Color.black)
                        .font(Font.system(size: 20.0))
                        .padding(.horizontal, 15)

                    Text("\(supplier.billingAmount)円")
                        .font(Font.system(size: 20.0))
                        .fontWeight(.bold)
                        .foregroundColor(Color.black)
                        .padding(.horizontal, 15)
                        .padding(.top, 5)
                }

                Spacer()
                Image(systemName: "chevron.forward")
                    .padding(.horizontal, 10)
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 15)
        .padding(.vertical, 15)
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
        )
    }
}

struct SupplierCell_Previews: PreviewProvider {
    static var previews: some View {
        SupplierCell(supplier: Supplier.mock, action: {})
    }
}
