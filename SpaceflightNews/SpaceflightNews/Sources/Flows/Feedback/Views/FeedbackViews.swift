// FeedbackViews.swift
// SpaceNewsApp — Presentation/Common/Views
//
// Vistas de feedback reutilizables en toda la app:
//   - LoadingView: spinner + mensaje "Buscando noticias..."
//   - ErrorStateView: error con botón de reintento
//   - EmptyStateView: estado vacío con ícono y mensaje

import SwiftUI

struct LoadingView: View {

    let message: String
    var onCancel: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            VStack(spacing: 20) {
                ProgressView()
                    .controlSize(.large)
                    .tint(.black)

                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
            
            if let onCancel = onCancel {
                Button(action: onCancel) {
                    Label("GO_TO_HOME".translate, systemImage: "house.fill")
                        .font(.headline)
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.black, lineWidth: 1.5)
                        )
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

struct ErrorStateView: View {

    let message: String
    let onRetry: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "wifi.exclamationmark")
                .font(.system(size: 56))
                .foregroundStyle(.red.opacity(0.8))
                .symbolEffect(.pulse)

            VStack(spacing: 8) {
                Text("SOMETHING_WENT_WRONG".translate)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.primary)

                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }

            Button(action: onRetry) {
                Label("Volver a intentar", systemImage: "arrow.clockwise")
                    .font(.headline)
                    .frame(minWidth: 200)
                    .padding(.vertical, 14)
                    .padding(.horizontal, 24)
                    .background(Color.accentColor)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

struct EmptyStateView: View {

    let icon: String
    let title: String
    let message: String

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 52))
                .foregroundStyle(.secondary)

            Text(title)
                .font(.title3.weight(.semibold))
                .foregroundStyle(.primary)

            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}
