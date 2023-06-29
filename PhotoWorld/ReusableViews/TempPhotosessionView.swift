//
//  TempPhotosessionView.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 27.04.2023.
//

import SwiftUI
import Kingfisher

struct PhotoshootCell: View {
    var item: PhotosessionListItem
    var openChat: ()->Void
    var acceptInvite: (String)->Void
    var declineInvite: (String)->Void
    
    var body: some View {
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
                .padding(.top, getRelativeHeight(10.0))
//                .padding(.horizontal, getRelativeWidth(16.0))
            
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
            
            
            Text(item.formatDate())
                .font(FontScheme.kInterRegular(size: getRelativeHeight(14.0)))
                .fontWeight(.regular)
                .foregroundColor(ColorConstants.Gray600)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.leading)
                .frame(width: getRelativeWidth(340), height: getRelativeHeight(24.0), alignment: .leading)
                .padding(.leading, getRelativeWidth(50.0))
            
            HStack {
                ForEach(0..<item.participants_avatars.count, id: \.self) { index in
                    if index < 3 {
                        if let imageURL = URL(string: item.participants_avatars[index].avatarUrl) {
                            KFImage(imageURL)
                                .resizable()
                                .placeholder({ Loader() })
                                .frame(width: getRelativeWidth(32.0),
                                       height: getRelativeWidth(32.0), alignment: .center)
                                .scaledToFit()
                                .clipShape(Circle())
                                .clipShape(Circle())
                        } else if let image = UIImage(named: "accountPlaceholder") {
                            Image(uiImage: image)
                                .resizable()
                                .frame(width: getRelativeWidth(32.0),
                                       height: getRelativeWidth(32.0), alignment: .center)
                                .scaledToFit()
                                .clipShape(Circle())
                                .clipShape(Circle())
                        }
                    }
                }
                
                if (item.participants_avatars.count > 3 ) {
                    Text("+\(item.participants_avatars.count - 3)")
                        .font(FontScheme
                            .kInterRegular(size: getRelativeHeight(14.0)))
                        .fontWeight(.regular)
                        .foregroundColor(ColorConstants.Bluegray300)
                        .minimumScaleFactor(0.5)
                        .multilineTextAlignment(.leading)
                        .frame(width: getRelativeWidth(19.0),
                               height: getRelativeHeight(14.0),
                               alignment: .topLeading)
                        .padding(.top, getRelativeHeight(12.0))
                        .padding(.bottom, getRelativeHeight(11.0))
                }
            }
            .frame(width: getRelativeWidth(340), alignment: .leading)
            .padding(.leading, getRelativeWidth(50.0))
            
            if item.photosessionStatus == .ready {
                Button(action: { openChat() }, label: {
                    Text("Перейти в чат")
                })
                    .padding(.vertical, getRelativeHeight(15))
                    .padding(.trailing, getRelativeWidth(45))
                    .buttonStyle(MainButtonStyle(width: getRelativeWidth(303), height: getRelativeHeight(35), backgoundColor: ColorConstants.Gray600, textColor: ColorConstants.WhiteA700))
            }
            else if item.photosessionStatus == .expectation {
                HStack {
                    Button(action: { acceptInvite(item.id) }, label: {
                        Text("Принять")
                    })
                        .buttonStyle(MainButtonStyle(width: getRelativeWidth(145), height: getRelativeHeight(35), backgoundColor: ColorConstants.Blue800, textColor: ColorConstants.WhiteA700))
                    
                    Button(action: { declineInvite(item.id) }, label: {
                        Text("Отказаться")
                    })
                        .buttonStyle(MainButtonStyle(width: getRelativeWidth(145), height: getRelativeHeight(35), backgoundColor: ColorConstants.Gray600, textColor: ColorConstants.WhiteA700))
                }.frame(width: getRelativeWidth(343), alignment: .center)
                    .padding(.vertical, getRelativeHeight(15))
                    .padding(.trailing, getRelativeWidth(45))
            } else {
                Text("").padding(.bottom, getRelativeHeight(10))
            }
        }
        .frame(width: getRelativeWidth(343), alignment: .topLeading)
        .background(RoundedCorners(topLeft: 8.0, topRight: 8.0, bottomLeft: 8.0,
                                   bottomRight: 8.0)
                .fill(ColorConstants.Bluegray800))
        
        
        
        
        
//            VStack(alignment: .leading, spacing: 0) {
//                VStack {
//                    VStack(alignment: .leading, spacing: 0) {
//
//
//
//
//
//                        VStack(alignment: .leading, spacing: 0) {
//
//                        }
//                        .frame(width: getRelativeWidth(196.0), height: getRelativeHeight(87.0),
//                               alignment: .leading)
//                        .padding(.top, getRelativeHeight(12.0))
//                        .padding(.horizontal, getRelativeWidth(16.0))
//                    }
//                    .frame(width: getRelativeWidth(342.0), height: getRelativeHeight(279.0),
//                           alignment: .center)
//                    .background(RoundedCorners(topLeft: 8.0, topRight: 8.0, bottomLeft: 8.0,
//                                               bottomRight: 8.0)
//                            .fill(ColorConstants.Bluegray800))
//                    .padding(.top, getRelativeHeight(24.0))
//                    .padding(.horizontal, getRelativeWidth(16.0))
//                }
//                .frame(width: UIScreen.main.bounds.width, height: getRelativeHeight(469.0),
//                       alignment: .leading)
//            }
//            .frame(width: UIScreen.main.bounds.width, alignment: .topLeading)
//            .background(ColorConstants.Bluegray900)
//            .padding(.top, getRelativeHeight(30.0))
//            .padding(.bottom, getRelativeHeight(10.0))
        
    }
}
