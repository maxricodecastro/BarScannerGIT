import SwiftUI

class BottomSheetViewModel: ObservableObject {
    @Published var data: BottomSheetData
    
    init(data: BottomSheetData = BottomSheetData.example) {
        self.data = data
    }
    
    // This will be useful later for API calls
    func updateData(_ newData: BottomSheetData) {
        data = newData
    }
}
