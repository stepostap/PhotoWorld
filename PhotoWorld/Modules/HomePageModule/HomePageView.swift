//
//  HomePageVieiw.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 24.04.2023.
//

import SwiftUI
import Kingfisher

struct HomePageView<model: HomePageViewModelIO>: View {
    @ObservedObject var viewModel: model
   
    var body: some View {
        VStack {
            VStack {
                ScrollView {
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
                            
                        Button(action: { viewModel.openSearchFilter() }, label: {
                            Image("searchOptions")
                                .resizable()
                                .foregroundColor(ColorConstants.Gray600)
                                .frame(width: getRelativeWidth(15.0), height: getRelativeHeight(15.0),
                                       alignment: .center)
                                .scaledToFill()
                                .padding()
                                .clipped()
                        })
                    }
                    .frame(width: getRelativeWidth(343), height: getRelativeHeight(50), alignment: .center)
                    .background(RoundedCorners(topLeft: 12, topRight: 12,
                                               bottomLeft: 12,
                                               bottomRight: 12)
                            .fill(ColorConstants.Bluegray800))
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .tint(ColorConstants.Blue800)
                            .progressViewStyle(.circular)
                            .frame(width: UIScreen.main.bounds.width,
                                   height: getRelativeHeight(600),
                                   alignment: .center)
                            .background(RoundedCorners(topLeft: 8.0, topRight: 8.0, bottomLeft: 8.0,
                                                       bottomRight: 8.0)
                                            .fill(ColorConstants.Bluegray900))
                    } else {
                        ForEach(viewModel.searchRes) { profile in
                            SearchProfileCell(userProfile: profile,
                                              buttonText: viewModel.searchCellButtonInfo!.title ?? "",
                                              buttonAction: { viewModel.searchCellButtonInfo!.buttonAction(profile) })
                            .onTapGesture {
                                viewModel.openAccount(info: profile)
                            }
                        }
                    }
                }
                .padding(.top, EdgeInsets.SafeAreaTopConstraint)
                .padding(.bottom, EdgeInsets.SafeAreaBottomTabBarConstraint)
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(ColorConstants.Bluegray900)
        .onAppear(perform: { viewModel.resendRequest() })
    }
}



