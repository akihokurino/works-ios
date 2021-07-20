
import SwiftUI

struct PickerItem: Hashable {
    let label: String
    let value: String
}

struct PickerInput: View {
    @Binding var selectIndex: Int
    @Binding var showPicker: Bool

    let label: String
    let selection: [PickerItem]

    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .foregroundColor(Color.gray)
                .font(.body)
                .padding(.bottom, 10)
            Button(action: {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                showPicker = true
            }) {
                Text(selection[selectIndex].label)
                    .foregroundColor(Color.black)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 15)
            .frame(height: 50)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.gray, lineWidth: 1)
            )
        }
    }
}

struct PickerInput_Previews: PreviewProvider {
    static var previews: some View {
        PickerInput(selectIndex: .constant(0), showPicker: .constant(true), label: "性別", selection: [
            PickerItem(label: "男性", value: "1"),
            PickerItem(label: "女性", value: "2")
        ])
    }
}

struct PickerView: View {
    @Binding var selectIndex: Int
    @Binding var showPicker: Bool

    let selection: [PickerItem]

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    showPicker = false
                }) {
                    Text("閉じる")
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                }
            }
            .frame(height: 40)

            Picker(selection: $selectIndex, label: Text("")) {
                ForEach(selection.indices, id: \.self) { index in
                    Text(selection[index].label).tag(index)
                }
            }
            .frame(width: 300)
            .labelsHidden()
        }
        .background(Color.white)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray)
                .opacity(0.5),
            alignment: .top
        )
    }
}

struct PickerView_Previews: PreviewProvider {
    static var previews: some View {
        PickerView(selectIndex: .constant(1), showPicker: .constant(true), selection: [])
    }
}
