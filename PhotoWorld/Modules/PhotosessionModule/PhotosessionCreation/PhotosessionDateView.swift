//
//  PhotosessionDateView.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 04.05.2023.
//

import SwiftUI
import SwiftUICalendar

struct PhotosessionDateView<model: PhotosessionDateViewModelIO>:  View {
    public init(viewModel: model) {
        UITextView.appearance().backgroundColor = .clear
        self.viewModel = viewModel
    }
    
    @ObservedObject var viewModel: model
    
    var body: some View {
        VStack {
            ProgressView(value: 1)
                .tint(Color.blue)
                .frame(width: getRelativeWidth(343), height: getRelativeHeight(2), alignment: .center)
                .padding(.top, getRelativeHeight(90))
            
            Text("Дата")
                .font(FontScheme.kInterMedium(size: getRelativeHeight(16.0)))
                .fontWeight(.medium)
                .foregroundColor(ColorConstants.WhiteA700)
                .frame(width: getRelativeWidth(343), height: getRelativeHeight(20.0), alignment: .leading)
                .padding(.top, getRelativeHeight(15))
            
            DataChoiceCalendar(chosenDate: $viewModel.chosenDate)
                .padding(30)
                .frame(width: getRelativeWidth(343), height: getRelativeHeight(343), alignment: .center)
                .background(RoundedCorners(topLeft: 8.0, topRight: 8.0, bottomLeft: 8.0,
                                           bottomRight: 8.0)
                                .fill(ColorConstants.Bluegray800))
            
            InputTextField(labelText: "Время начала съемки", text: $viewModel.time, placeholder: "00:00")
                .padding(.vertical, getRelativeHeight(20))
            
            TextField("Продолжительность", value: $viewModel.duration, format: .number)
                .font(FontScheme.kInterMedium(size: getRelativeHeight(14.0)))
                .foregroundColor(ColorConstants.WhiteA700)
                .padding()
                .placeholder(when: viewModel.duration == nil, placeholder: {
                    Text("Длительность съемки в часах").foregroundColor(Color.gray).padding()
                        .font(FontScheme.kInterMedium(size: getRelativeHeight(14.0)))
                })
                .frame(width: getRelativeWidth(343), height: getRelativeHeight(45.0), alignment: .center)
                .background(RoundedCorners(topLeft: 8.0, topRight: 8.0, bottomLeft: 8.0,
                                           bottomRight: 8.0)
                    .fill(ColorConstants.Bluegray800))
            
            Spacer()
            
            Button(action: {
                viewModel.createPhotosession()
            }, label: {
                Text("Отправить")
            })
                .disabled(!viewModel.infoFilled())
                .buttonStyle(MainButtonStyle(backgoundColor: viewModel.infoFilled() ? ColorConstants.BlueA700 : ColorConstants.Bluegray300,
                                             textColor: ColorConstants.WhiteA700))
                .padding([.bottom], getRelativeHeight(EdgeInsets.SafeAreaBottomConstraint))
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(ColorConstants.Bluegray900)
        .ignoresSafeArea()
    }
}

