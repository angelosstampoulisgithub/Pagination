//
//  PaginationViewModel.swift
//  SwiftUIPagination
//
//  Created by angelos on 16/03/2026.
//

import Foundation
import SwiftUI
import Combine


@MainActor
final class PaginationViewModel: ObservableObject {
    @Published var items: [String] = []
    @Published var isLoading = false
    @Published var currentPage = 1

    private let pageSize = 10
    private let maxPage = 10   // or nil if you want infinite

    init() {
        loadPage(currentPage)
    }

    func loadNextPage() {
        guard !isLoading else { return }
        guard currentPage < maxPage else { return }
        currentPage += 1
        loadPage(currentPage)
    }

    func loadPreviousPage() {
        guard !isLoading else { return }
        guard currentPage > 1 else { return }
        currentPage -= 1
        loadPage(currentPage)
    }

    private func loadPage(_ page: Int) {
        isLoading = true

        Task {
            try? await Task.sleep(nanoseconds: 300_000_000)

            let start = (page - 1) * pageSize
            let newItems = (0..<pageSize).map { "Item \(start + $0)" }

            await MainActor.run {
                self.items = newItems      
                self.isLoading = false
            }
        }
    }
}

