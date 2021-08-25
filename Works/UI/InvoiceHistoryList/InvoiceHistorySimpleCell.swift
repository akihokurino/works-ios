import SwiftUI

struct InvoiceHistorySimpleCell: View {
    let history: InvoiceHistory
    let action: () -> Void

    var body: some View {
        Button(action: {
            action()
        }) {
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(history.supplier.name) / \(history.invoice.totalAmount + history.invoice.tax)円")
                            .font(Font.system(size: 14.0))
                            .foregroundColor(Color.black)

                        HStack {
                            Text("支払い期日: \(history.invoice.paymentDueOnYMD)")
                                .font(Font.system(size: 12.0))
                                .foregroundColor(Color.black)
                                .padding(.trailing, 5)

                            Group {
                                Text(history.invoice.paymentStatusText)
                                    .font(Font.system(size: 12.0))
                                    .foregroundColor(Color.white)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 1)
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(history.invoice.paymentStatus == .unPaid ? Color.red.opacity(0.5) : Color.blue.opacity(0.5), lineWidth: 1)
                            )
                            .background(history.invoice.paymentStatus == .unPaid ? Color.red.opacity(0.5) : Color.blue.opacity(0.5))

                            Group {
                                Text(history.invoice.invoiceStatusText)
                                    .font(Font.system(size: 12.0))
                                    .foregroundColor(Color.white)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 1)
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(history.invoice.invoiceStatus == .unSubmitted ? Color.red.opacity(0.5) : Color.blue.opacity(0.5), lineWidth: 1)
                            )
                            .background(history.invoice.invoiceStatus == .unSubmitted ? Color.red.opacity(0.5) : Color.blue.opacity(0.5))
                        }
                        .padding(.top, 1)
                    }

                    Spacer()
                    Image(systemName: "chevron.forward")
                }
                .padding(.horizontal, 15)

                Divider().background(Color.gray.opacity(0.5))
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
    }
}

struct InvoiceHistorySimpleCell_Previews: PreviewProvider {
    static var previews: some View {
        InvoiceHistorySimpleCell(history: InvoiceHistory.mock, action: {})
    }
}
