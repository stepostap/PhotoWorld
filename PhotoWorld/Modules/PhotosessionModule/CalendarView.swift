//
//  CalendarView.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 19.05.2023.
//

import Foundation
import SwiftUI
import SwiftUICalendar

struct PhotosessionsCalendarView: View {
    @ObservedObject var controller: CalendarController = CalendarController(isLocked: true)
    @State var chosenDate: YearMonthDay
    let viewModel: any PhotosessionListViewModelIO
    
    var dates: [YearMonthDay] {
        return viewModel.photosessionList.map { $0.getDate() }
    }
    
    var photosessionForDate: [PhotosessionListItem] {
        return viewModel.photosessionList.filter({ item in item.getDate() == chosenDate })
    }
    
    func scrollToNextMonth() {
        controller.scrollTo(year: controller.yearMonth.year, month: controller.yearMonth.month + 1, isAnimate: true)
    }
    
    func scrollToPreviousMonth() {
        controller.scrollTo(year: controller.yearMonth.year, month: controller.yearMonth.month - 1, isAnimate: true)
    }
    
    var body: some View {
        VStack {
            GeometryReader { reader in
                VStack {
                    HStack {
                        Button(action: { scrollToPreviousMonth() }, label: {
                            Image(systemName: "chevron.left")
                                .foregroundColor(ColorConstants.WhiteA700)
                        })
                        
                        Text("\(controller.yearMonth.monthShortString)  \(String(controller.yearMonth.year))")
                            .font(FontScheme.kInterMedium(size: getRelativeHeight(20.0)))
                            .fontWeight(.medium)
                            .foregroundColor(ColorConstants.WhiteA700)
                            .padding(.horizontal, getRelativeWidth(15))
                            .frame(width: getRelativeWidth(140), alignment: .center)
                        Button(action: { scrollToNextMonth() }, label: {
                            Image(systemName: "chevron.right")
                                .foregroundColor(ColorConstants.WhiteA700)
                        })
                    }.frame(alignment: .center)
                    
                    CalendarView(controller, startWithMonday: true, headerSize: .fixHeight(50.0)) { week in
                        Text("\(week.shortString)")
                            .font(.headline)
                            .frame(width: reader.size.width / 7)
                            .foregroundColor(ColorConstants.WhiteA700)
                    } component: { date in
                        GeometryReader { geometry in
                            //if dates.contains(where: { temp in temp==date}) {
                                Text("\(date.day)")
                                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                                    .font(.system(size: 14, weight: .bold, design: .default))
                                    .foregroundColor(YearMonthDay.current == date ? ColorConstants.Red400 : ColorConstants.WhiteA700)
                                    .background(RoundedCorners(topLeft: 8.0, topRight: 8.0, bottomLeft: 8.0,
                                                               bottomRight: 8.0)
                                        .fill(chosenDate == date ? ColorConstants.Blue800 : ColorConstants.Bluegray900))
                                    .opacity(date.isFocusYearMonth == true ? 1 : 0.4)
                                    .onTapGesture {
                                        chosenDate = date
                                    }
                            if dates.contains(where: { temp in temp==date}) {
                                Rectangle()
                                    .foregroundColor(ColorConstants.Red400)
                                    .frame(width: geometry.size.width, height: 2, alignment: .center)
                            }
//                            }
//                            else {
//                                Text("\(date.day)")
//                                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
//                                    .font(.system(size: 14, weight: .light, design: .default))
//                                    .foregroundColor(ColorConstants.WhiteA700)
//                                    .opacity(date.isFocusYearMonth == true ? 1 : 0.4)
//                                    .onTapGesture {
//                                        chosenDate = date
//                                    }
//                            }
                        }
                    }
                }
            }
            .frame(width: getRelativeWidth(300), height: getRelativeHeight(230), alignment: .center)
            .overlay(RoundedCorners(topLeft: 8.0, topRight: 8.0, bottomLeft: 8.0, bottomRight: 8.0)
                        .stroke(ColorConstants.Bluegray800 , lineWidth: 1))
            .padding(.bottom, getRelativeHeight(10))
            List()
        }.frame(alignment: .center)
    }
    
    @ViewBuilder func List() -> some View {
        ScrollView(.vertical) {
            VStack {
                ForEach(photosessionForDate) { item in
                    VStack {
                        item.photosessionStatus.statusTag()
                            .frame(width: getRelativeWidth(340.0), alignment: .leading)
                            .padding(.leading, 16.0)
                            .padding(.top, getRelativeHeight(16.0))
                        
                        Text(item.name)
                            .font(FontScheme.kInterMedium(size: getRelativeHeight(20.0)))
                            .fontWeight(.medium)
                            .foregroundColor(ColorConstants.WhiteA700)
                            .minimumScaleFactor(0.5)
                            .multilineTextAlignment(.leading)
                            .frame(width: getRelativeWidth(340.0), height: getRelativeHeight(24.0),
                                   alignment: .leading)
                            .padding(.leading, 16.0)
                            //.padding(.top, getRelativeHeight(10.0))
                        
                        HStack {
                            Image("img_mappin")
                                .resizable()
                                .frame(width: getRelativeWidth(20.0),
                                       height: getRelativeHeight(20.0), alignment: .center)
                                .scaledToFit()
                                .clipped()
                            
                            Text(item.address)
                                .font(FontScheme.kInterRegular(size: getRelativeHeight(16.0)))
                                .fontWeight(.regular)
                                .foregroundColor(ColorConstants.WhiteA700)
                                .minimumScaleFactor(0.5)
                                .multilineTextAlignment(.leading)
                        }
                        .frame(width: getRelativeWidth(340), height: getRelativeHeight(24.0), alignment: .leading)
                        .padding(.horizontal, getRelativeWidth(16.0))
                        
                        HStack {
                            Image("img_clock")
                                .resizable()
                                .frame(width: getRelativeWidth(20.0),
                                       height: getRelativeWidth(20.0), alignment: .center)
                                .scaledToFit()
                                .clipped()
                            
                            Text(item.formatTime())
                                .font(FontScheme.kInterRegular(size: getRelativeHeight(16.0)))
                                .fontWeight(.regular)
                                .foregroundColor(ColorConstants.WhiteA700)
                                .minimumScaleFactor(0.5)
                                .multilineTextAlignment(.leading)
                                .frame(width: getRelativeWidth(101.0),
                                       height: getRelativeHeight(16.0), alignment: .topLeading)
                            
                        }
                        .frame(width: getRelativeWidth(340), height: getRelativeHeight(24.0), alignment: .leading)
                        .padding(.horizontal, getRelativeWidth(16.0))
                        
                        
                        Button(action: { viewModel.openChat(url: item.chat_url) }, label: {
                            Text("Перейти в чат")
                        })
                        .padding(.bottom, getRelativeHeight(10))
                        .padding(.trailing, getRelativeWidth(45))
                        .buttonStyle(MainButtonStyle(width: getRelativeWidth(303), height: getRelativeHeight(35), backgoundColor: ColorConstants.Gray600, textColor: ColorConstants.WhiteA700))
                    }
                    .frame(width: getRelativeWidth(343), alignment: .topLeading)
                    .background(RoundedCorners(topLeft: 8.0, topRight: 8.0, bottomLeft: 8.0,
                                               bottomRight: 8.0)
                        .fill(ColorConstants.Bluegray800))
                    .onTapGesture {
                        viewModel.openPhotosession(id: item.id)
                    }
                }
            }
        }
    }
}
