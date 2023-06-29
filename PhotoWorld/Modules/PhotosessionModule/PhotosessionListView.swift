//
//  PhotosessionListView.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 26.04.2023.
//

import SwiftUI
import SwiftUICalendar

enum PhotosessionViewRepresentation {
    case calendar
    case list
}

extension PhotosessionViewRepresentation {
    var representationName: String {
        switch self {
        case .calendar:
            return "Календарь"
        case .list:
            return "Список"
        }
    }
}

struct PhotoSessionListView<model: PhotosessionListViewModelIO>: View {
    
    @State var photoSessionViewRepresentation: PhotosessionViewRepresentation = PhotosessionViewRepresentation.list
    @ObservedObject var viewModel: model
    
    var body: some View {
        VStack {
            VStack {
                Text("Мои фотосессии")
                    .font(FontScheme.kInterMedium(size: getRelativeHeight(24.0)))
                    .fontWeight(.medium)
                    .foregroundColor(ColorConstants.WhiteA700)
                    .frame(width: getRelativeWidth(343.0), height: getRelativeHeight(24.0),
                           alignment: .leading)
                
                if viewModel.refresh { Text("").frame(width: 0, height: 0) }
                
                HStack {
                    Menu {
                        Button {
                            photoSessionViewRepresentation = .calendar
                        } label: {
                            Text("Календарь")
                        }
                        Button {
                            photoSessionViewRepresentation = .list
                        } label: {
                            Text("Список")
                        }
                    } label: {
                        HStack {
                            Text(photoSessionViewRepresentation.representationName)
                                .foregroundColor(ColorConstants.WhiteA700)
                            Image(systemName: "chevron.down")
                        }.frame(width: getRelativeWidth(110), height: getRelativeHeight(25), alignment: .center)
                            .background(RoundedCorners(topLeft: 8.0, topRight: 8.0,
                                                       bottomLeft: 8.0, bottomRight: 8.0)
                                            .fill(ColorConstants.Gray600))
                    }
                    
                    Spacer()
                    
                    Button(action: { viewModel.openPhotosessionCreation() }, label: {
                        HStack {
                            Text("Создать фотосессию")
                            Image(systemName: "plus")
                                .resizable()
                                .frame(width: getRelativeWidth(14.0),
                                       height: getRelativeWidth(14.0), alignment: .leading)
                                .scaledToFit()
                                .clipped()
                                .padding(.vertical, getRelativeHeight(14.0))
        
                        }
                    })
                        .buttonStyle(MainButtonStyle(width: getRelativeWidth(180), height: getRelativeHeight(27), fontSize: 14.0, backgoundColor: ColorConstants.BlueA700, textColor: ColorConstants.WhiteA700))
                    
                }.frame(width: getRelativeWidth(343), height: getRelativeHeight(25), alignment: .center)
                    .padding()
                
                if photoSessionViewRepresentation == .list {
                    ScrollView(showsIndicators: false) {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .resizable()
                                .foregroundColor(ColorConstants.Gray600)
                                .frame(width: getRelativeWidth(15.0), height: getRelativeHeight(15.0),
                                       alignment: .center)
                                .scaledToFill()
                                .padding()
                                .clipped()
                            
                            TextField("", text: $viewModel.searchQueue)
                                .foregroundColor(ColorConstants.WhiteA700)
                                .placeholder(when: viewModel.searchQueue.isEmpty, placeholder: {
                                    Text("Поиск").foregroundColor(Color.gray)
                                        .font(FontScheme.kInterMedium(size: getRelativeHeight(14.0)))
                                })
                        }
                        .frame(width: getRelativeWidth(343), height: getRelativeHeight(35), alignment: .center)
                        .background(RoundedCorners(topLeft: 12, topRight: 12,
                                                   bottomLeft: 12,
                                                   bottomRight: 12)
                                .fill(ColorConstants.Bluegray800))
                        
                        CustomSegmentController(choiceOptions: ["Все", "В работе", "Архив", "Приглашения"],
                                                selected: $viewModel.photoSessionTypeSelection)
                        .frame(width: getRelativeWidth(343), height: getRelativeHeight(25), alignment: .center)
                        
                        ForEach(viewModel.shownPhotosessions) { item in
                            PhotoshootCell(item: item,
                                           openChat: { viewModel.openChat(url: item.chat_url) },
                                           acceptInvite: viewModel.acceptInvite,
                                           declineInvite: viewModel.declineInvite)
                                .onTapGesture {
                                    viewModel.openPhotosession(id: item.id)
                                }
                        }.padding(.top, 15)
                    }
                } else {
                    PhotosessionsCalendarView(chosenDate: YearMonthDay.current, viewModel: viewModel)
                }
            }
            .padding(.top, getRelativeHeight(60))
            .padding(.bottom, getRelativeHeight(65))
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(ColorConstants.Bluegray900)
        .onAppear(perform: { viewModel.showTabBar() })
    }
}
