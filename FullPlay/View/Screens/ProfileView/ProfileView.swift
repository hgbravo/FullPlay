//
//  ProfileView.swift
//  FullPlay
//
//  Created by Henry Bravo on 2/4/22.
//

import SwiftUI
import CloudKit

struct ProfileView: View {
    
    static let tag = 2
    @StateObject private var viewModel = ProfileViewModel()
    @FocusState private var focusedTextField: ProfileTextField?
    
    enum ProfileTextField {
        case firstName, lastName, companyName, bio
    }
    
    var body: some View {
        
        ZStack {
            VStack {
                ZStack {
                    NameBackgroundView()
                    
                    HStack(spacing: 15) {
                        ProfileImageView(image: viewModel.avatar)
                        .onTapGesture { viewModel.isShowingPhotoPicker = true }
                        
                        VStack(alignment: .leading, spacing: 1) {
                            TextField("First Name", text: $viewModel.firstName)
                                .profileNameStyle()
                                .focused($focusedTextField, equals: .firstName)
                                .onSubmit { focusedTextField = .lastName }
                                .submitLabel(.next)
                            
                            TextField("Last Name", text: $viewModel.lastName)
                                .profileNameStyle()
                                .focused($focusedTextField, equals: .lastName)
                                .onSubmit { focusedTextField = .companyName }
                                .submitLabel(.next)
                            
                            TextField("Company Name", text: $viewModel.social)
                                .focused($focusedTextField, equals: .companyName)
                                .onSubmit { focusedTextField = .bio }
                                .submitLabel(.next)
                        }
                        .padding(.trailing, 16)
                        
                        Spacer()
                    }
                    .padding(.leading, 30)
                }
                
                HStack {
                    Spacer()
                    
                    if viewModel.isCheckedIn {
                        Button {
                            viewModel.checkOut()
                        } label: {
                            Label("Check Out", systemImage: "mappin.and.ellipse")
                        }
                        .accessibilityLabel(Text("Check out of current location"))
                        .buttonStyle(.bordered)
                        .tint(.fullPlayRed)
                        .disabled(viewModel.isLoading)
                    }
                }
                .padding()
                
                VStack(alignment: .leading) {
                    CharacterRemainView(currentCount: viewModel.bio.count)
                        .accessibilityAddTraits(.isHeader)
                    
                    BioTextEditor(text: $viewModel.bio)
                        .focused($focusedTextField, equals: .bio)
                }
                .padding(.horizontal)
                
                Spacer()
                
                Button {
                    viewModel.determineButtonAction()
                } label: {
                    Text(viewModel.buttonTitle)
                        .frame(width: 295, height: 44)
                }
                .buttonStyle(.bordered)
                .tint(.brandPrimary)
                .padding(.vertical, 30)
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Dismiss") { focusedTextField = nil }
                }
            }
            
            if viewModel.isLoading { LoadingView() }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(DeviceTypes.isiPhone8Standard ? .inline : .automatic)
        .ignoresSafeArea(.keyboard)
        .task {
            viewModel.getProfile()
            viewModel.isCheckedInStatus()
        }
        .alert(item: $viewModel.alertItem, content: { $0.alert })
        .sheet(isPresented: $viewModel.isShowingPhotoPicker) { PhotoPicker(image: $viewModel.avatar) }
    }
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileView()
        }
    }
}


fileprivate struct NameBackgroundView: View {
    var body: some View {
        Rectangle()
            .foregroundColor(Color(uiColor: .secondarySystemBackground))
            .frame(height: 130)
            .cornerRadius(15)
            .padding(.horizontal)
    }
}


fileprivate struct ProfileImageView: View {
    var image: UIImage
    
    var body: some View {
        ZStack {
            AvatarView(image: image, size: 84)
            
            Image(systemName: "square.and.pencil")
                .resizable()
                .scaledToFill()
                .frame(width: 14, height: 14)
                .foregroundColor(.white)
                .offset(y: 32)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityAddTraits(.isButton)
        .accessibilityLabel(Text("Profile photo"))
        .accessibilityHint(Text("Opens the iPhone's photo picker"))
        
        
    }
}


fileprivate struct CharacterRemainView: View {
    
    var currentCount: Int
    
    var body: some View {
        Text("Bio: ")
            .font(.caption)
            .foregroundColor(.secondary)
        +
        Text("\(100 - currentCount)")
            .bold()
            .font(.caption)
            .foregroundColor(currentCount <= 100 ? .brandPrimary : .brandSecondary)
        +
        Text(" characters remaining")
            .font(.caption)
            .foregroundColor(.secondary)
    }
}

struct BioTextEditor: View {
    
    var text: Binding<String>
    
    var body: some View {
        TextEditor(text: text)
            .frame(height: 100)
            .overlay { RoundedRectangle(cornerRadius: 10).stroke(Color.secondary, lineWidth: 1) }
            .accessibilityHidden(true)
            .accessibilityHint(Text("This Textfield is for your bio and has a 100 characters maximum."))
    }
}
