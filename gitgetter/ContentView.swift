//
//  ContentView.swift
//  JumboInteractiveTestApp
//
//  Created by Josh Bourke on 16/10/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var user: GitHubUserModel?
    @State private var userFollowers: [GitHubFollowersModel] = []
    @State private var userRepos: [GitHubUserRepos] = []
    
    
    @State private var followerProfile: GitHubFollowerAccountModel?
    @State private var followerRepos: [GitHubFollowerRepos] = []
    

    
    let networkManager = NetworkManager()
    
    @State private var showEditUserView: Bool = false
    
    @State private var username: String = "joshuabourke"
    
    enum SelectedBodyState {
        case repos
        case friends
    }
    
    @State var selectedBodyState: SelectedBodyState = .friends
    
    var body: some View {
        NavigationStack {
                ScrollView(showsIndicators: false) {
                    VStack {
                        // User display and tabs
                        returnUserDisplayView()
                        // Sliding content based on selectedBodyState
                        switch selectedBodyState {
                        case .repos:
                            returnReposView(repos: userRepos)
                        case .friends:
                            returnUsersFollowersView()
                        }
                    }//: VSTACK
                }//: SCROLL VIEW
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .returnDefaultBackgroundView()
                .navigationTitle("Git Getter")
                .toolbar(content: {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            showEditUserView.toggle()
                        }, label: {
                            HStack {
                                Image(systemName: "pencil")
                                    .bold()
                                Text("Edit")
                                    .bold()
                            }
                            .padding(.vertical, 2)
                            .padding(.horizontal, 6)
                            .background(RoundedRectangle(cornerRadius: 12).opacity(0.3))
                        })
                    }
                })
                .task {
                    await setUser(username: username)
                    await getUserFollowers(username: username)
                    userRepos = await getRepos(username: username)
                }
                .sheet(isPresented: $showEditUserView, onDismiss: {
                    Task {
                        await setUser(username: username)
                        await getUserFollowers(username: username)
                        userRepos = await getRepos(username: username)
                    }
                }, content: {
                    EditUserNameView(userNameText: $username, isEditUserOpen: $showEditUserView)
                        .presentationDetents([.height(240)])
                        .presentationDragIndicator(.visible)
                })
        }
    }
    
    //MARK: - FUNCS
    func setUser(username: String) async {
        do {
            user = try await networkManager.getUser(username: username)
        } catch {
            handleErrorGHError(error, context: "User")
        }

    }
    
    func getUserFollowers(username: String) async {
        do {
            userFollowers = try await networkManager.getUserFollowers(username: username)
        } catch {
            handleErrorGHError(error, context: "User Followers")
        }
    }
    
    func getFollowerEndPoint(followerEndPoint: String) async {
        do {
            followerProfile = try await networkManager.getFollowerAccountDetails(followerEndPoint: followerEndPoint)
        } catch {
            handleErrorGHError(error, context: "Follower Profile")
        }
    }
    
    func getRepos<T: GitHubRepoProtocol>(username: String) async -> [T]  {
        do {
            return try await networkManager.getRepoList(username: username)
        } catch {
            handleErrorGHError(error, context: "User Repos")
            return []
        }
    }
    
    //MARK: - SUBVIEW
    func returnUserDisplayView() -> some View {
        Group {
            VStack {
                VStack(spacing: 10) {
                    HStack {
                        if let userImage = user?.avatarUrl {
                            AsyncImage(url: URL(string: userImage)) { image in
                                image
                                    .resizable()
                                    .clipShape(Circle())
                            } placeholder: {
                                Circle()
                                    .fill(.gray).opacity(0.3)
                            }
                        } else {
                            Circle()
                                .fill(.gray).opacity(0.3)
                        }
                    }//: HSTACK
                    .frame(width: 100, height: 100)
                    Text(user?.login ?? "N/A")
                        .font(.title)
                        .bold()
                    Text(user?.bio ?? "User bio does not exsist.")
                        .multilineTextAlignment(.center)
                        .bold()
                        .foregroundColor(.gray)
                        .font(.callout)
                }//: VSTACK
                HStack {
                    Button {
                        withAnimation {
                            selectedBodyState = .friends
                        }
                    } label: {
                        HStack{
                            Image(systemName: selectedBodyState == .friends ? "person.3.fill" : "person.3")
                                .bold()
                                .foregroundStyle(selectedBodyState == .friends ? .white : .blue)
                            Text("Followers")
                                .bold()
                                .foregroundStyle(selectedBodyState == .friends ? .white : .blue)
                        }//: HSTACK
                        .padding(4)
                        .background(RoundedRectangle(cornerRadius: 6).opacity(selectedBodyState == .friends ? 1 : 0.3))
                    }
                    
                    Button {
                        withAnimation {
                            selectedBodyState = .repos
                        }
                    } label: {
                        HStack{
                            Image(systemName: selectedBodyState == .repos ? "apple.terminal.fill" : "apple.terminal")
                                .bold()
                                .foregroundStyle(selectedBodyState == .repos ? .white : .blue)
                            Text("Repos")
                                .bold()
                                .foregroundStyle(selectedBodyState == .repos ? .white : .blue)
                        }//: HSTACK
                        .padding(4)
                        .background(RoundedRectangle(cornerRadius: 6).opacity(selectedBodyState == .repos ? 1 : 0.3))
                    }
                }//: HSTACK
            }//: VSTACK
            .returnContentBackgroundModifier()
        }
    }
    
    func returnUsersFollowersView() -> some View {
        Group {
            LazyVStack(alignment: .leading) {
                HStack {
                    Text("Followers")
                        .font(.title3)
                        .bold()
                        .foregroundStyle(.gray)
                    Spacer()
                    Text("(\(userFollowers.count))")
                        .font(.body)
                        .bold()
                        .foregroundStyle(.gray)
                }//: HSTACK
                ForEach(userFollowers, id: \.self) { follower in
                    NavigationLink {
                        returnFollowerDetailedView(login: follower.login,followerURL: follower.url)
                    } label: {
                        HStack {
                            HStack {
                                let userImage = follower.avatarUrl
                                AsyncImage(url: URL(string: userImage)) { image in
                                    image
                                        .resizable()
                                        .clipShape(Circle())
                                } placeholder: {
                                    Circle()
                                        .fill(.gray).opacity(0.3)
                                }
                            }//: HSTACK
                            .frame(width: 75, height: 75)
                            Text(follower.login)
                                .font(.title3)
                                .bold()
                                .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                                .bold()
                        }//: HSTACK
                        .returnContentBackgroundModifier()
                    }
                }
                Spacer()
            }//: VSTACK
            .frame(maxHeight: .infinity)
        }
    }
    
    func returnReposView<T: GitHubRepoProtocol>(repos: [T]) -> some View {
        Group {
            LazyVStack(alignment: .leading) {
                HStack {
                    Text("Repos")
                        .font(.title3)
                        .bold()
                        .foregroundStyle(.gray)
                    Spacer()
                    Text("(\(repos.count))")
                        .font(.body)
                        .bold()
                        .foregroundStyle(.gray)
                }//: HSTACK
                ForEach(repos, id: \.self) { repo in
                    VStack(alignment: .leading) {
                        Text(repo.name)
                            .font(.headline)
                            .bold()
                            .padding(.bottom, 4)
                        Text(repo.description ?? "No repo description")
                            .multilineTextAlignment(.leading)
                            .bold()
                            .foregroundColor(.gray)
                            .font(.callout)
                        HStack {
                            if repo.repoHtmlUrl == "" {
                                Button {
                                    
                                } label: {
                                    HStack {
                                        Image(systemName: "globe")
                                            .bold()
                                            .foregroundColor(.gray)
                                        Text("Link")
                                            .bold()
                                            .foregroundColor(.gray)
                                    }//: HSTACK
                                    .padding(.vertical, 4)
                                    .padding(.horizontal, 6)
                                    .background(RoundedRectangle(cornerRadius: 6).fill(.gray).opacity(0.3))
                                }
                                .disabled(true)
                            } else {
                                Link(destination: URL(string: repo.repoHtmlUrl)!, label: {
                                    HStack {
                                        Image(systemName: "globe")
                                            .bold()
                                        Text("Link")
                                            .bold()
                                    }//: HSTACK
                                    .padding(.vertical, 4)
                                    .padding(.horizontal, 6)
                                    .background(RoundedRectangle(cornerRadius: 6).opacity(0.3))
                                })
                            }
                            HStack {
                                Image(systemName: "eye")
                                    .bold()
                                Text("Watchers: \(repo.watchers ?? 0)")
                                    .font(.caption)
                                    .bold()
                            }//: HSTACK
                            .padding(.vertical, 4)
                            .padding(.horizontal, 6)
                            .background(RoundedRectangle(cornerRadius: 12).fill(.ultraThickMaterial))
                            HStack {
                                Image(systemName: "star.fill")
                                    .bold()
                                    .foregroundColor(.yellow)
                                Text("Stars: \(repo.stargazersCount ?? 0)")
                                    .font(.caption)
                                    .bold()
                            }//: HSTACK
                            .padding(.vertical, 4)
                            .padding(.horizontal, 6)
                            .background(RoundedRectangle(cornerRadius: 12).fill(.ultraThickMaterial))
                            Spacer()
                        }//: HSTACK
                    }//: VStack
                    .returnContentBackgroundModifier()
                }
                Spacer()
            }
            .frame(maxHeight: .infinity)
        }//: VSTACK
    }
    
    func returnFollowerDetailedView(login: String, followerURL: String) -> some View {
        Group {
            ScrollView {
                Group {
                    VStack(spacing: 10) {
                        HStack {
                            if let userImage = followerProfile?.avatarUrl {
                                AsyncImage(url: URL(string: userImage)) { image in
                                    image
                                        .resizable()
                                        .clipShape(Circle())
                                } placeholder: {
                                    Circle()
                                        .fill(.gray).opacity(0.3)
                                }
                            } else {
                                Circle()
                                    .fill(.gray).opacity(0.3)
                            }
                        }//: HSTACK
                        .frame(width: 100, height: 100)
                        Text(login)
                            .font(.title)
                            .bold()
                        Text(followerProfile?.bio ?? "User bio does not exsist.")
                            .multilineTextAlignment(.center)
                            .bold()
                            .foregroundColor(.gray)
                            .font(.callout)
                    }//: VSTACK
                    .returnContentBackgroundModifier()
                }
                returnReposView(repos: followerRepos)
            }
            .navigationBarTitleDisplayMode(.inline)
            .padding()
            .returnDefaultBackgroundView()
            .task {
                await getFollowerEndPoint(followerEndPoint: followerURL)
                followerRepos = await getRepos(username: login)
            }
            .onDisappear() {
                followerProfile = nil
            }
        }
    }
}

#Preview {
    ContentView()
}
