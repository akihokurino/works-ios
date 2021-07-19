import SwiftUI

struct PinCodeInputView: View {
    var maxDigits: Int = 6
    var label = "Pinコードを入力してください"
    
    @State var pin: String = ""
    @State var isDisabled = false
    
    var onSubmit: (String) -> Void
    
    public var body: some View {
        VStack(spacing: 10) {
            Text(label)
                .foregroundColor(Color.gray)
                .font(.title)
            Spacer().frame(height: 20)
            ZStack {
                pinDots
                backgroundField
            }
        }
    }
    
    private var pinDots: some View {
        HStack {
            Spacer()
            ForEach(0 ..< maxDigits) { index in
                Image(systemName: self.getImageName(at: index))
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(.gray)
                    .font(.system(size: 14, weight: .ultraLight, design: .default))
                    .frame(width: 50, height: 50, alignment: .center)
                Spacer()
            }
        }
    }
    
    private var backgroundField: some View {
        let boundPin = Binding<String>(get: { self.pin }, set: { newValue in
            self.pin = newValue
            self.submitPin()
        })
        
        return TextField("", text: boundPin, onCommit: submitPin)
            .accentColor(.clear)
            .foregroundColor(.clear)
            .keyboardType(.numberPad)
            .disabled(isDisabled)
    }
    
    private func submitPin() {
        guard !pin.isEmpty else {
            return
        }
        
        if pin.count == maxDigits {
            isDisabled = true
            onSubmit(pin)
        }
        
        if pin.count > maxDigits {
            pin = String(pin.prefix(maxDigits))
            submitPin()
        }
    }
    
    private func getImageName(at index: Int) -> String {
        if index >= pin.count {
            return "square"
        }
        
        return pin.digits[index].numberString + ".square"
    }
}
