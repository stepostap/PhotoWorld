//
//  SearchFilters.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 13.05.2023.
//

import Foundation
import SwiftUI

struct SearchFiltersView: View {
    init(searchFilter: SearchFilter, saveFilter: @escaping ()->Void) {
        origin = searchFilter
        filter = SearchFilter(filter: searchFilter)
        self.saveFilter = saveFilter
    }
    
    let origin: SearchFilter
    @ObservedObject var filter: SearchFilter
    var saveFilter: ()->Void
    
    var body: some View {
        VStack {
            ScrollView {
                TitleText(text: "Категория")
                    .padding(.top, 10)
            
                HStack {
                    profileTypeButton(type: .photographer).padding(.trailing, getRelativeWidth(10))
                    
                    profileTypeButton(type: .model).padding(.trailing, getRelativeWidth(10))
                    
                    profileTypeButton(type: .stylist).padding(.trailing, getRelativeWidth(10))
                }.frame(width: getRelativeWidth(343), height: getRelativeHeight(35), alignment: .leading)
                
                TitleText(text: "Стаж работы")
                
                HStack {
                    TextField("От", value: $filter.startExp, format: .number)
                        .font(FontScheme.kInterMedium(size: getRelativeHeight(14.0)))
                        .foregroundColor(ColorConstants.WhiteA700)
                        .padding()
                        .placeholder(when: filter.startExp == nil, placeholder: {
                            Text("От 1 года").foregroundColor(Color.gray).padding()
                                .font(FontScheme.kInterMedium(size: getRelativeHeight(14.0)))
                        })
                        .frame(width: getRelativeWidth(165), height: getRelativeHeight(30.0), alignment: .center)
                        .background(RoundedCorners(topLeft: 8.0, topRight: 8.0, bottomLeft: 8.0,
                                                   bottomRight: 8.0)
                                        .fill(ColorConstants.Bluegray800))
                        
                    TextField("До", value: $filter.endExp, format: .number)
                        .font(FontScheme.kInterMedium(size: getRelativeHeight(14.0)))
                        .foregroundColor(ColorConstants.WhiteA700)
                        .padding()
                        .placeholder(when: filter.endExp == nil, placeholder: {
                            Text("До 40 лет").foregroundColor(Color.gray).padding()
                                .font(FontScheme.kInterMedium(size: getRelativeHeight(14.0)))
                        })
                        .frame(width: getRelativeWidth(165), height: getRelativeHeight(30.0), alignment: .center)
                        .background(RoundedCorners(topLeft: 8.0, topRight: 8.0, bottomLeft: 8.0,
                                                   bottomRight: 8.0)
                                        .fill(ColorConstants.Bluegray800))
                    
                }.frame(width: getRelativeWidth(343), height: getRelativeHeight(35), alignment: .center)
                
                Toggle("Только избранные", isOn: $filter.chosenUsersOnly)
                    .toggleStyle(SwitchToggleStyle(tint: ColorConstants.BlueA700))
                    .foregroundColor(ColorConstants.WhiteA700)
                    .frame(width: getRelativeWidth(343), alignment: .center)
                    .padding()
                
                TitleText(text: "Рейтинг от")
                
                TextField("От", value: $filter.startingRating, format: .number)
                    .font(FontScheme.kInterMedium(size: getRelativeHeight(14.0)))
                    .foregroundColor(ColorConstants.WhiteA700)
                    .padding()
                    .placeholder(when: filter.startingRating == nil, placeholder: {
                        Text("Написать...").foregroundColor(Color.gray).padding()
                            .font(FontScheme.kInterMedium(size: getRelativeHeight(14.0)))
                    })
                    .frame(width: getRelativeWidth(343), height: getRelativeHeight(45.0), alignment: .center)
                    .background(RoundedCorners(topLeft: 8.0, topRight: 8.0, bottomLeft: 8.0,
                                               bottomRight: 8.0)
                                    .fill(ColorConstants.Bluegray800))
                
                TitleText(text: "Теги")
                    .padding(.top, getRelativeHeight(10))
                
                ForEach(0 ..< filter.tags.count, id: \.self) { index in
                    Toggle(isOn: $filter.tags[index].present) {
                        Text(filter.tags[index].tag)
                            .font(FontScheme.kInterMedium(size: getRelativeHeight(14.0)))
                            .foregroundColor(ColorConstants.WhiteA700)
                            .padding(.leading, 10)
                    }
                    .frame(width: getRelativeWidth(343), height: getRelativeHeight(30), alignment: .leading)
                    .toggleStyle(CheckboxStyle(size: .big))
                    .padding(.bottom, 20)
                }
            }.padding(.top, EdgeInsets.SafeAreaTopConstraint)
            
            Button(action: { save() }, label: {
                Text("Сохранить")
            })
                .buttonStyle(MainButtonStyle(backgoundColor: ColorConstants.BlueA700,
                                             textColor: ColorConstants.WhiteA700))
                .padding([.bottom], getRelativeHeight(EdgeInsets.SafeAreaBottomConstraint))
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(ColorConstants.Bluegray900)
    }
    
    func switchType(type: ProfileType) {
        filter.chosenType = type
        if let newTags = ProfileTypeTags.getTags(forType: type) {
            filter.setTags(newTags: newTags)
        }
    }
    
    func save() {
        origin.chosenUsersOnly = filter.chosenUsersOnly
        origin.startingRating = filter.startingRating
        origin.tags = filter.tags
        origin.startExp = filter.startExp
        origin.endExp = filter.endExp
        origin.chosenType = filter.chosenType
        saveFilter()
    }
    
//    @ViewBuilder func titleText(text: String) -> some View {
//        Text(text)
//            .font(FontScheme.kInterMedium(size: getRelativeHeight(18.0)))
//            .fontWeight(.bold)
//            .foregroundColor(ColorConstants.WhiteA700)
//            .frame(width: getRelativeWidth(343.0), height: getRelativeHeight(24.0),
//                   alignment: .topLeading)
//    }
    
    @ViewBuilder func profileTypeButton(type: ProfileType) -> some View {
        Button(action: { switchType(type: type) }, label: {
            Text(type.title)
                .font(FontScheme.kInterMedium(size: getRelativeHeight(14.0)))
                .fontWeight(.medium)
                .padding(getRelativeWidth(5))
                .foregroundColor(ColorConstants.WhiteA700)
                .frame(width: getRelativeWidth(100), height: getRelativeHeight(25.0), alignment: .center)
                .background(RoundedCorners(topLeft: 8.0, topRight: 8.0, bottomLeft: 8.0,
                                           bottomRight: 8.0)
                                .fill(filter.chosenType == type ? ColorConstants.Blue800 : ColorConstants.Bluegray700))
        })
    }
}


