//
//  DataChoiceCalendar.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 04.05.2023.
//

import SwiftUI
import SwiftUICalendar

//DataChoiceCalendar(chosenDate: $chosenDate)
//    .padding(30)
//    .frame(width: getRelativeWidth(300), height: getRelativeHeight(300), alignment: .center)
//    .background(RoundedCorners(topLeft: 8.0, topRight: 8.0, bottomLeft: 8.0,
//                               bottomRight: 8.0)
//                    .fill(ColorConstants.Bluegray900))

struct DataChoiceCalendar: View {
    @ObservedObject var controller: CalendarController = CalendarController(isLocked: true)
    @Binding var chosenDate: YearMonthDay
    
    func scrollToNextMonth() {
        controller.scrollTo(year: controller.yearMonth.year, month: controller.yearMonth.month + 1, isAnimate: true)
    }
    
    func scrollToPreviousMonth() {
        controller.scrollTo(year: controller.yearMonth.year, month: controller.yearMonth.month - 1, isAnimate: true)
    }
    
    var body: some View {
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
                        if date == chosenDate {
                            Text("\(date.day)")
                                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                                .font(.system(size: 14, weight: .bold, design: .default))
                                .foregroundColor(ColorConstants.WhiteA700)
                                .background(RoundedCorners(topLeft: 8.0, topRight: 8.0, bottomLeft: 8.0,
                                                           bottomRight: 8.0)
                                                .fill(ColorConstants.Blue800))
                        } else {
                            Text("\(date.day)")
                                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                                .font(.system(size: 14, weight: .light, design: .default))
                                .foregroundColor(ColorConstants.WhiteA700)
                                .opacity(date.isFocusYearMonth == true ? 1 : 0.4)
                                .onTapGesture {
                                    chosenDate = date
                                }
                        }
                    }
                }
            }
        }
    }
}
