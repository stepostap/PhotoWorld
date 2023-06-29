//
//  ServicePaymentView.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 05.05.2023.
//

import SwiftUI

struct ServicePaymentView: View {
    internal init(service: UserServiceInfo, saveChanges: @escaping () -> Void) {
        self.saveChanges = saveChanges
        self.service = UserServiceInfo(serviceInfo: service)
        self.origin = service
        if let _ = service.startPrice, let _ = service.endPrice {
            showTwoTextfields = true
        } else {
            showTwoTextfields = false
        }
    }
    
    let saveChanges: ()->Void
    @State var showTwoTextfields: Bool
    @ObservedObject var service: UserServiceInfo
    let origin: UserServiceInfo
    
    var body: some View {
        VStack {
            HStack {
                Text("Цена")
                    .font(FontScheme.kInterMedium(size: getRelativeHeight(14.0)))
                    .foregroundColor(ColorConstants.WhiteA700)
                
                Spacer()
                
                Menu {
                    Button {
                        service.paymentType = .fixed
                    } label: {
                        Text("Фиксированная ценя")
                    }
                    
                    Button {
                        service.paymentType = .perHour
                    } label: {
                        Text("Часовая оплата")
                    }
                } label:  {
                    HStack {
                        Text(paymentTypeShortDescription())
                            .foregroundColor(ColorConstants.WhiteA700)
                        Image(systemName: "chevron.right")
                    }.frame(width: getRelativeWidth(80), alignment: .trailing)
                }
            }
            .frame(width: getRelativeWidth(343), height: getRelativeHeight(15), alignment: .center)
            .padding(.top, EdgeInsets.SafeAreaTopTabBarConstraint)
            
            if !showTwoTextfields {
                TextField("priceFixed", value: $service.startPrice, format: .number)
                    .padding()
                    .placeholder(when: service.startPrice == nil, placeholder: {
                        Text("Укажите цену...").foregroundColor(Color.gray).padding()
                            .font(FontScheme.kInterMedium(size: getRelativeHeight(14.0)))
                    })
                    .font(FontScheme.kInterMedium(size: getRelativeHeight(14.0)))
                    .foregroundColor(ColorConstants.WhiteA700)
                    .frame(width: getRelativeWidth(343), height: getRelativeHeight(45.0), alignment: .center)
                    .background(RoundedCorners(topLeft: 8.0, topRight: 8.0, bottomLeft: 8.0,
                                               bottomRight: 8.0)
                                    .fill(ColorConstants.Bluegray800))
            } else {
                HStack {
                    TextField("startPrice", value: $service.startPrice, format: .number)
                        .padding()
                        .placeholder(when: service.startPrice == nil, placeholder: {
                            Text("От").foregroundColor(Color.gray).padding()
                                .font(FontScheme.kInterMedium(size: getRelativeHeight(14.0)))
                        })
                        .font(FontScheme.kInterMedium(size: getRelativeHeight(14.0)))
                        .foregroundColor(ColorConstants.WhiteA700)
                        .frame(width: getRelativeWidth(165), height: getRelativeHeight(45.0), alignment: .center)
                        .background(RoundedCorners(topLeft: 8.0, topRight: 8.0, bottomLeft: 8.0,
                                                   bottomRight: 8.0)
                                        .fill(ColorConstants.Bluegray800))
                    
                    TextField("endPrice", value: $service.endPrice, format: .number)
                        .padding()
                        .placeholder(when: service.endPrice == nil, placeholder: {
                            Text("До").foregroundColor(Color.gray).padding()
                                .font(FontScheme.kInterMedium(size: getRelativeHeight(14.0)))
                        })
                        .font(FontScheme.kInterMedium(size: getRelativeHeight(14.0)))
                        .foregroundColor(ColorConstants.WhiteA700)
                        .frame(width: getRelativeWidth(165), height: getRelativeHeight(45.0), alignment: .center)
                        .background(RoundedCorners(topLeft: 8.0, topRight: 8.0, bottomLeft: 8.0,
                                                   bottomRight: 8.0)
                                        .fill(ColorConstants.Bluegray800))
                }.frame(width: getRelativeWidth(343), alignment: .center)
            }
            
            Toggle("Указать диапазон", isOn: $showTwoTextfields)
                .toggleStyle(SwitchToggleStyle(tint: ColorConstants.BlueA700))
                .foregroundColor(ColorConstants.WhiteA700)
                .frame(width: getRelativeWidth(343), alignment: .center)
                .padding()
            
            Spacer()
            
            Button(action: { save() }, label: {
                Text("Сохранить")
            })
                //.disabled(service.startPrice != nil)
                .buttonStyle(MainButtonStyle(backgoundColor: ColorConstants.BlueA700,
                                             textColor: ColorConstants.WhiteA700))
                .padding([.bottom], getRelativeHeight(EdgeInsets.SafeAreaBottomConstraint))
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(ColorConstants.Bluegray900)
        .ignoresSafeArea()
    }
    
    func save() {
        origin.startPrice = service.startPrice
        if !showTwoTextfields {
            origin.endPrice = nil
        } else {
            origin.endPrice = service.endPrice
        }
        origin.paymentType = service.paymentType
        saveChanges()
    }
    
    func paymentTypeShortDescription() -> String {
        switch service.paymentType {
        case .perHour:
            return "чаc."
        case .fixed:
            return "фикс."
        }
    }
}
