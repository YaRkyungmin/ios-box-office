//
//  DailyBoxOfficeData.swift
//  BoxOffice
//
//  Created by kyungmin, Erick on 2023/08/01.
//

import UIKit

typealias RankStateColor = (targetString: String, color: UIColor)

struct DailyBoxOfficeData: Hashable {
    let id = UUID()
    let rank: String
    let rankState: String
    let movieTitle: String
    let dailyAndTotalAudience: String
    let rankStateColor: RankStateColor

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func ==(lhs: DailyBoxOfficeData, rhs: DailyBoxOfficeData) -> Bool {
        return lhs.id == rhs.id
    }
}
