import SwiftUI

struct InvoiceHistoryCell: View {
    let history: InvoiceHistory
    let action: () -> Void

    var body: some View {
        Button(action: {
            action()
        }) {
            HStack {
                Image(systemName: "doc.fill")
                    .resizable()
                    .foregroundColor(.gray)
                    .frame(width: 45, height: 60)

                VStack(alignment: .leading) {
                    Text("請求先: \(history.supplier.name)")
                        .font(Font.system(size: 15.0))
                        .foregroundColor(Color.black)
                        .padding(.horizontal, 15)
                    
                    Text(history.invoice.subject)
                        .foregroundColor(Color.black)
                        .font(Font.system(size: 15.0))
                        .padding(.horizontal, 15)
                        .padding(.top, 2)

                    Text("\(history.invoice.totalAmount + history.invoice.tax)円（税込）")
                        .font(Font.system(size: 15.0))
                        .fontWeight(.bold)
                        .foregroundColor(Color.black)
                        .padding(.horizontal, 15)
                        .padding(.top, 2)

                    Text("発行日: \(history.invoice.issueYMD)")
                        .font(Font.system(size: 15.0))
                        .foregroundColor(Color.black)
                        .padding(.horizontal, 15)
                        .padding(.top, 2)
                    Text("支払い期日: \(history.invoice.paymentDueOnYMD)")
                        .font(Font.system(size: 15.0))
                        .foregroundColor(Color.black)
                        .padding(.horizontal, 15)
                        .padding(.top, 2)

                    HStack {
                        Group {
                            Text(history.invoice.paymentStatusText)
                                .font(Font.system(size: 12.0))
                                .foregroundColor(Color.white)
                                .padding(.horizontal, 15)
                                .padding(.vertical, 2)
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
                                .padding(.horizontal, 15)
                                .padding(.vertical, 2)
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(history.invoice.invoiceStatus == .unSubmitted ? Color.red.opacity(0.5) : Color.blue.opacity(0.5), lineWidth: 1)
                        )
                        .background(history.invoice.invoiceStatus == .unSubmitted ? Color.red.opacity(0.5) : Color.blue.opacity(0.5))
                    }
                    .padding(.leading, 15)
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
    }
}

struct InvoiceHistoryCell_Previews: PreviewProvider {
    static var previews: some View {
        InvoiceHistoryCell(history: InvoiceHistory.mock, action: {})
    }
}
