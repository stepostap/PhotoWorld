//
//  ServicesView.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 05.05.2023.
//

import SwiftUI

struct ServicesView<model: ServicesViewModelIO>: View {
    @ObservedObject var viewModel: model
    @ObservedObject var services: UserServices
    var progress: Double = 0.6
    
    public init(viewModel: model) {
        self.viewModel = viewModel
        services = viewModel.services
    }
    
    var body: some View {
        VStack {
            ProgressView(value: progress)
                .tint(Color.blue)
                .frame(width: getRelativeWidth(343), height: getRelativeHeight(2), alignment: .center)
                .padding(.top, EdgeInsets.SafeAreaTopTabBarConstraint)
                .padding(.bottom, getRelativeHeight(20))
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    ForEach(services.userServices) { serviceInfo in
                        serviceCell(serviceInfo: serviceInfo,
                                    editPriceAction: { viewModel.editPrice(service: serviceInfo) },
                                    deleteServiceAction: {
                            let index = services.userServices.firstIndex(where: { serive in serive.serviceName == serviceInfo.serviceName} )
                            if let index = index {
                                services.userServices.remove(at: index)
                            }
                        })
                        
                        Rectangle()
                            .foregroundColor(ColorConstants.Gray600)
                            .frame(width: getRelativeWidth(343), height: 1, alignment: .center)
                            .padding(.bottom, getRelativeHeight(10))
                    }
                }
                
                Button(action: { viewModel.getServices() }, label: {
                    Text("Добавить услуги")
                })
                    .frame(width: getRelativeWidth(343), height: getRelativeHeight(20), alignment: .center)
                    .padding(.top, getRelativeHeight(20))
            }
            
            Spacer()
        
            Button(action: { viewModel.saveServices() }, label: {
                Text(services.userServices.isEmpty ? "Пропустить":"Отправить")
            })
                .buttonStyle(MainButtonStyle(backgoundColor: ColorConstants.BlueA700,
                                             textColor: ColorConstants.WhiteA700))
                .padding([.bottom], getRelativeHeight(EdgeInsets.SafeAreaBottomConstraint))
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(ColorConstants.Bluegray900)
        .ignoresSafeArea()
    }
}

@ViewBuilder func serviceCell(serviceInfo:  UserServiceInfo,
                              editPriceAction: @escaping ()->Void,
                              deleteServiceAction: @escaping ()->Void ) -> some View {
    HStack {
        VStack {
            Text(serviceInfo.serviceName)
                .font(FontScheme.kInterMedium(size: getRelativeHeight(16.0)))
                .foregroundColor(ColorConstants.WhiteA700)
                .padding(.bottom, getRelativeHeight(5))
            
            if let price = serviceInfo.priceDescription() {
                Text(price.description)
                    .font(FontScheme.kInterMedium(size: getRelativeHeight(16.0)))
                    .foregroundColor(ColorConstants.WhiteA700)
                    .padding(.bottom, getRelativeHeight(5))
            }
            
            Button(action: { editPriceAction() }, label: {
                HStack {
                    Text("Редактировать")
                        .font(FontScheme.kInterMedium(size: getRelativeHeight(14.0)))
                        .foregroundColor(ColorConstants.WhiteA700)
                    Image(systemName: "pencil")
                        .frame(width: getRelativeWidth(15), height: getRelativeHeight(15), alignment: .center)
                        .foregroundColor(ColorConstants.WhiteA700)
                }
            })
                .frame(width: getRelativeWidth(140), height: getRelativeHeight(20), alignment: .center)
                .background(RoundedCorners(topLeft: 8.0, topRight: 8.0, bottomLeft: 8.0,
                                           bottomRight: 8.0)
                                .fill(ColorConstants.Bluegray300))
           
        }.frame(maxWidth: .infinity, alignment: .topLeading)
        
        Spacer()
        
        Button(action: { deleteServiceAction() }, label: {
            Image(systemName: "trash").foregroundColor(ColorConstants.Red400)
                .frame(width: getRelativeWidth(25), height: getRelativeHeight(25), alignment: .center)
        })
    }
    .frame(width: getRelativeWidth(343), alignment: .leading)
    .padding(.bottom, getRelativeHeight(10))
}
