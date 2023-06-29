//
//  PhotosessionTagsView.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 04.05.2023.
//

import SwiftUI
import SwiftUICalendar

struct PhotosessionTagsView<model: PhotosessionTagsViewModelIO>: View {
    @ObservedObject var viewModel: model
    @State var progress = 0.25

    var body: some View {
        VStack {
            ProgressView(value: progress)
                .tint(Color.blue)
                .frame(width: getRelativeWidth(343), height: getRelativeHeight(2), alignment: .center)
                .padding(.top, getRelativeHeight(90))
            ScrollView {
                Text("Какая фотосессия?")
                    .foregroundColor(ColorConstants.WhiteA700)
                    .font(FontScheme.kInterMedium(size: getRelativeHeight(18.0)))
                    .frame(width: getRelativeWidth(343), height: getRelativeHeight(22), alignment: .leading)
                    .padding(.bottom, getRelativeHeight(10))
                
                ForEach(0 ..< viewModel.sessionTags.count, id: \.self) { index in
                    Toggle(isOn: $viewModel.sessionTags[index].present) {
                        Text(viewModel.sessionTags[index].tag)
                            .font(FontScheme.kInterMedium(size: getRelativeHeight(14.0)))
                            .foregroundColor(ColorConstants.WhiteA700)
                            .padding(.leading, 10)
                    }
                    .frame(width: getRelativeWidth(343), height: getRelativeHeight(30), alignment: .leading)
                    .toggleStyle(CheckboxStyle(size: .big))
                    .padding(.bottom, 20)
                }
            }.padding(.top, getRelativeHeight(15))

            Button(action: { viewModel.passChosenSpecs() }, label: {
                Text("Отправить")
            })
                .disabled(!viewModel.tagsChosen)
                .buttonStyle(MainButtonStyle(backgoundColor: viewModel.tagsChosen ?
                                             ColorConstants.BlueA700 : ColorConstants.Bluegray300,
                                             textColor: ColorConstants.WhiteA700))
                .padding([.bottom], getRelativeHeight(EdgeInsets.SafeAreaBottomConstraint))
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(ColorConstants.Bluegray900)
        .ignoresSafeArea()
    }
}
