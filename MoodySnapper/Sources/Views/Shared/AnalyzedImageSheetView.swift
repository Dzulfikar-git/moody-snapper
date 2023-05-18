//
//  AnalyzedImageSheetView.swift
//  MoodySnapper
//
//  Created by Dzulfikar on 17/05/23.
//

import SwiftUI

struct AnalyzedImageSheetView: View {
    @Binding var isPresentingSheet: Bool
    @Binding var comment: String
    
    let onSaveClicked: () -> Void
    let onCancelClicked: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8.0) {
            HStack {
                Button {
                    onCancelClicked()
                } label: {
                    Text("Cancel")
                }
                
                Spacer()
                
                Button {
                    onSaveClicked()
                } label: {
                    Text("Save")
                }
            }.padding([.top], 16.0)
            Text("Write your moments.")
                .font(.title3)
                .fontWeight(.semibold)
            TextEditor(text: $comment)
                .border(.black, width: 1.0)
        }
        .padding([.horizontal], 16.0)
        .presentationDetents([.medium])
        .presentationDragIndicator(.hidden)
    }
}

struct AnalyzedImageSheetView_Previews: PreviewProvider {
    struct AnalyzedImageSheetViewPreviewer: View {
        @State var isPresenting: Bool = false
        @State var comment: String = ""
        
        var body: some View {
            AnalyzedImageSheetView(isPresentingSheet: $isPresenting, comment: $comment, onSaveClicked: {
                
            }, onCancelClicked: {
                
            })
        }
    }
    
    static var previews: some View {
        AnalyzedImageSheetViewPreviewer()
    }
}
