//
//  EditUserNameView.swift
//  JumboInteractiveTestApp
//
//  Created by Josh Bourke on 16/10/2024.
//

import SwiftUI

struct EditUserNameView: View {
    @Binding var userNameText: String
    @Binding var isEditUserOpen: Bool
    
    let networkManager = NetworkManager()
    var body: some View {
        VStack {
            VStack {
                Text("Edit Username")
                    .bold()
                    .padding(8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Enter the Github user name you would like to look up...")
                    .frame(maxWidth: .infinity)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .frame(height: .infinity)
                HStack {
                    TextField("Github Username..", text: $userNameText)
                        .padding()
                        .bold()
                        .background(RoundedRectangle(cornerRadius: 12).fill(.ultraThickMaterial))
                }//: HSTACK
                Button {
                    isEditUserOpen.toggle()
                } label: {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .bold()
                        Text("Search User")
                            .font(.title3)
                            .bold()
                    }//: HSTACK
                    .padding(.vertical, 4)
                    .padding(.horizontal, 6)
                    .frame(width: UIScreen.main.bounds.width / 2)
                    .background(RoundedRectangle(cornerRadius: 20).opacity(0.3))
                }
            }//: VSTACK
            .returnContentBackgroundModifier()
            .frame(height: 200)
            Spacer()
        }//: VSTACK
        .padding()
        .frame(maxWidth: .infinity)
        .returnDefaultBackgroundView()
    }
    
}

#Preview {
    EditUserNameView(userNameText: .constant(""), isEditUserOpen: .constant(false))
}
