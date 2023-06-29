//
//  PhotosessionView.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 14.05.2023.
//

import Foundation
import SwiftUI
import Kingfisher

struct PhotosessionView<model: PhotosessionViewModelIO>: View {

    var viewModel: model
    @State var participantTypeIndex: Int = 0
    @State var refresh = false
    
    func formatTime() -> String {
        let startDate = Date(milliseconds:  viewModel.photosession.start_date_and_time)
        let endDate = Date(milliseconds: viewModel.photosession.end_date_and_time)
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        let daystr = formatter.string(from: startDate) + "\n"
        formatter.dateFormat = "HH:mm"
        let timestr = "\(formatter.string(from: startDate)) - \(formatter.string(from: endDate))"
        return daystr + timestr
    }
    
    var body: some View {
        VStack {
            ScrollView(.vertical) {
                VStack {
                    Group {
                        TitleText(text: "Описание")
                        Text(viewModel.photosession.description)
                            .font(FontScheme.kInterMedium(size: getRelativeHeight(14.0)))
                            .foregroundColor(ColorConstants.WhiteA700)
                            .multilineTextAlignment(.leading)
                            .frame(width: getRelativeWidth(343), alignment: .leading)
                            .padding(.bottom, getRelativeHeight(15))
                        
                        TitleText(text: "Продолжительность съемки")
                        Text("\(viewModel.photosession.duration) часов")
                            .font(FontScheme.kInterMedium(size: getRelativeHeight(14.0)))
                            .foregroundColor(ColorConstants.WhiteA700)
                            .frame(width: getRelativeWidth(343), alignment: .leading)
                            .padding(.bottom, getRelativeHeight(15))
                        
                        TitleText(text: "Место проведения")
                        Text(viewModel.photosession.address)
                            .font(FontScheme.kInterMedium(size: getRelativeHeight(14.0)))
                            .foregroundColor(ColorConstants.WhiteA700)
                            .frame(width: getRelativeWidth(343), alignment: .leading)
                            .padding(.bottom, getRelativeHeight(15))
                        
                        TitleText(text: "Дата и время")
                        Text(formatTime())
                            .font(FontScheme.kInterMedium(size: getRelativeHeight(14.0)))
                            .foregroundColor(ColorConstants.WhiteA700)
                            .frame(width: getRelativeWidth(343), alignment: .leading)
                            .padding(.bottom, getRelativeHeight(15))
                    }
                    
                    Group {
                        if !viewModel.photosession.tags.isEmpty {
                            TitleText(text: "Теги")
                                .padding(.top, getRelativeHeight(10))
                            
                            VStack {
                                ForEach(0..<(viewModel.photosession.tags.count+1)/2, id: \.self) { row in
                                    let index = row * 2
                                    HStack {
                                        TagView(text: viewModel.photosession.tags[index])
                                        if index+1 < viewModel.photosession.tags.count {
                                            TagView(text: viewModel.photosession.tags[index+1])
                                        }
                                    }.frame(width: getRelativeWidth(343), alignment: .leading)
                                }
                            }.padding(.bottom, getRelativeHeight(10))
                        }
                    }
                    
                    Group {
                        if let photos = viewModel.photosession.photos, !photos.isEmpty {
                            TitleText(text: "Фотографии и файлы")
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(0..<photos.count, id: \.self) {index in
                                        KFImage(photos[index])
                                            .resizable()
                                            .frame(width: getRelativeWidth(140),
                                                   height: getRelativeHeight(140), alignment: .leading)
                                            .scaledToFit()
                                            .clipped()
                                            .cornerRadius(8)
                                    }
                                }
                            }.frame(width: getRelativeWidth(343), height: getRelativeHeight(145), alignment: .center)
                                .padding(.bottom, getRelativeHeight(15))
                                .onTapGesture(perform: {
                                    viewModel.openImages()
                                })
                        }
                    }
                    
                    Group {
                        TitleText(text: "Организатор")
                        ProfileCellView(imageURL: URL(string: viewModel.photosession.organizer.avatar_url),
                                        profileType: viewModel.photosession.organizer.profile_type,
                                        name: viewModel.photosession.organizer.name,
                                        rating: viewModel.photosession.organizer.rating,
                                        commentsCount: viewModel.photosession.organizer.comments_number)
                    }
                    
                    Group {
                        TitleText(text: "Участники")
                        CustomSegmentController(choiceOptions: ["Все","Визажист","Модель","Фотограф"],
                                                selected: $participantTypeIndex)
                            .frame(width: getRelativeWidth(343), height: getRelativeHeight(25), alignment: .leading)
                        VStack {
                            ForEach(viewModel.filterParticipants(index: participantTypeIndex)) { el in
                                ParticipantCellView(participant: el, openParticipantView: { viewModel.openAccount(participant: el) })
                                    .padding(.vertical, getRelativeHeight(5))
                            }
                        }
                        
                        if viewModel.isOrganizer() {
                            Button(action: { viewModel.inviteUsers() }, label: {
                                Text("Добавить участника")
                                    .font(FontScheme.kInterMedium(size: getRelativeHeight(14.0)))
                            })
                            .buttonStyle(.borderless)
                            .frame(width: getRelativeWidth(343), alignment: .center)
                            .padding(.top, getRelativeHeight(20))
                        }
                        
                        if refresh {
                            Text("").frame(width: 0, height: 0, alignment: .center)
                        }
                    }

                    
                    bottomButtons()
                }
            }
            .ignoresSafeArea()
            .padding(.top, EdgeInsets.SafeAreaTopConstraint)
            .padding(.bottom, EdgeInsets.SafeAreaBottomConstraint)
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .top)
        .background(ColorConstants.Bluegray900)
        .onAppear(perform: {
            refresh.toggle()
            viewModel.hideTabBar()
        } )
    }
    
    @ViewBuilder func bottomButtons() -> some View {
        if viewModel.isOrganizer() {
            HStack {
                Button(action: { viewModel.openChat() }, label: {
                    Text("Написать")
                })
                .padding([.bottom], getRelativeHeight(10.0))
                .buttonStyle(MainButtonStyle(width: getRelativeWidth(165),
                                             backgoundColor: ColorConstants.BlueA700,
                                             textColor: ColorConstants.WhiteA700))

                Button(action: { viewModel.finishPhotosession() }, label: {
                    Text("Завершить")
                })
                .padding([.bottom], getRelativeHeight(10.0))
                .buttonStyle(MainButtonStyle(width: getRelativeWidth(165),
                                             backgoundColor: ColorConstants.WhiteA700,
                                             textColor: Color.black))
            }.frame(width: getRelativeWidth(343), alignment: .center)
                .padding(.top, getRelativeHeight(20))
        } else {
            Button(action: { viewModel.openChat() }, label: {
                Text("Написать")
            })
            .padding([.bottom], getRelativeHeight(10.0))
            .buttonStyle(MainButtonStyle(width: getRelativeWidth(343),
                                         backgoundColor: ColorConstants.BlueA700,
                                         textColor: ColorConstants.WhiteA700))
        }
    }
}
