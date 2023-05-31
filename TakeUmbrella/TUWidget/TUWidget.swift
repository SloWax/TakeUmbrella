//
//  TUWidget.swift
//  TUWidget
//
//  Created by 표건욱 on 2023/05/23.
//

import WidgetKit
import SwiftUI


struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> WeatherEntry {
        WeatherEntry(
            date: Date(),
            day: "1.1 (오늘)",
            time: "00:00",
            location: "서울",
            icon: "01d",
            description: "맑음",
            temp: 55.5,
            tempMin: -99.1,
            tempMax: 99.1
        )
    }
    
    // 위젯 갤러리에서 보여주기 위한 스냅샷
    func getSnapshot(in context: Context, completion: @escaping (WeatherEntry) -> ()) {
        let entry = WeatherEntry(
            date: Date(),
            day: "1.1 (오늘)",
            time: "00:00",
            location: "서울",
            icon: "01d",
            description: "맑음",
            temp: 55.5,
            tempMin: -99.1,
            tempMax: 99.1
        )
        
        completion(entry)
    }
    
    // 위젯 새로고침 스케쥴
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [WeatherEntry] = []
        let data = DataManager.shared.retrieve()
        
        let currentDate = Date()
        
        for hourOffset in 0 ..< 24 {
            let value = hourOffset * 3
            let entryDate = Calendar.current.date(
                byAdding: .hour,
                value: value,
                to: currentDate
            )!
            
            var entry = data[hourOffset].toEntry
            entry.date = entryDate
            
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }
}

struct WeatherEntry: TimelineEntry {
    var date: Date
    
    let day: String
    let time: String
    let location: String
    let icon: String
    let description: String
    let temp: Double
    let tempMin: Double
    let tempMax: Double
}

struct TUWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack {
            Text("\(entry.day) \(entry.time)")
                .font(.setCustomFont(font: .medium, size: 14))
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top)
                .padding(.horizontal)
            
            Text(entry.temp.toString("%.1f°"))
                .font(.setCustomFont(font: .black, size: 32))
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.horizontal)
            
            HStack(alignment: .bottom) {
                Image(entry.icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                
                Text(entry.location)
                    .font(.setCustomFont(font: .regular, size: 16))
                
                Text(entry.description)
                    .font(.setCustomFont(font: .regular, size: 16))
                    .padding(.trailing)
            }
            
            HStack {
                Text(entry.tempMax.toString("⤒ %.1f°"))
                    .font(.setCustomFont(font: .regular, size: 18))
                    .padding(.leading)
                
                Spacer()
                
                Text(entry.tempMin.toString("⤓ %.1f°"))
                    .font(.setCustomFont(font: .regular, size: 18))
                    .padding(.trailing)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom)
        }
    }
}

struct TUWidget: Widget {
    let kind: String = "TUWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            TUWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("엄마가비온대")
        .description("내 위치 날씨정보 위젯")
    }
}

struct TUWidget_Previews: PreviewProvider {
    static var previews: some View {
        let entry = WeatherEntry(
            date: Date(),
            day: "날짜",
            time: "시간",
            location: "주소",
            icon: "01d",
            description: "맑음",
            temp: 55.5,
            tempMin: -99.1,
            tempMax: 99.1
        )
        
        TUWidgetEntryView(entry: entry)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
