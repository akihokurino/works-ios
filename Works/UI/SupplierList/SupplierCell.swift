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
                    .frame(width: 60, height: 60)

                VStack(alignment: .leading) {
                    Text(supplier.name)
                        .foregroundColor(Color.black)
                        .font(Font.system(size: 20.0))
                        .padding(.horizontal, 15)

                    Text("\(supplier.billingAmountIncludeTax)円（税込）")
                        .font(Font.system(size: 20.0))
                        .fontWeight(.bold)
                        .foregroundColor(Color.black)
                        .padding(.horizontal, 15)
                        .padding(.top, 5)
                }

                Spacer()
                Image(systemName: "chevron.forward")
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 15)
        .padding(.vertical, 15)
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
        )
        .background(supplier.billingType == .monthly ? Color.green.opacity(0.1) : Color.orange.opacity(0.1))
    }
}

struct SupplierCell_Previews: PreviewProvider {
    static var previews: some View {
        SupplierCell(supplier: Supplier.mock, action: {})
    }
}
