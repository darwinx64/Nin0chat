//
//  ContributorRowView.swift
//  Wcode
//
//  Created by tiramisu on 10/19/24.
//

/// src: https://github.com/CodeEditApp/CodeEdit/blob/main/CodeEdit/Features/About/Contributors/ContributorRowView.swift

import SwiftUI

struct ContributorRowView: View {

    let contributor: Contributor

    var body: some View {
        HStack {
            userImage
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(contributor.name)
                        .font(.headline)
                }
                HStack(spacing: 3) {
                    Text(contributor.description)
                        .font(.caption)
                        .padding(.vertical, 1)
                }
            }
            Spacer()
            HStack(alignment: .top) {
                if let profileURL = contributor.profileURL, profileURL != contributor.gitHubURL {
                    ActionButton(url: profileURL, image: .init(systemName: "globe"))
                }
                if let gitHubURL = contributor.gitHubURL {
                    ActionButton(url: gitHubURL, image: .github)
                }
            }
        }
        .padding(.vertical, 8)
    }

    private var userImage: some View {
        AsyncImage(url: contributor.avatarURL) { image in
            image
                .resizable()
                .frame(width: 32, height: 32)
                .clipShape(Circle())
                .help(contributor.name)
        } placeholder: {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 32, height: 32)
                .help(contributor.name)
        }
    }
    
    private struct ActionButton: View {
        @Environment(\.openURL)
        private var openURL
        @State private var hovering = false

        let url: URL
        let image: Image

        var body: some View {
            Button {
                openURL(url)
            } label: {
                image
                    .imageScale(.medium)
                    .foregroundColor(hovering ? .primary : .secondary)
            }
            .buttonStyle(.plain)
            .onHover { hover in
                hovering = hover
            }
        }
    }
}
