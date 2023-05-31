//
//  TUWidget.swift
//  TUWidget
//
//  Created by 표건욱 on 2023/05/23.
//

import WidgetKit
import SwiftUI


struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
//        SimpleEntry(date: Date(), testString: "000")
        SimpleEntry(
            date: Date(),
            day: "000",
            time: "000",
            location: "동도옫ㅇ",
            icon: "01d",
            description: "000",
            temp: 0.01,
            tempMin: 0.01,
            tempMax: 0.01
        )
    }
    
    // 위젯 갤러리에서 보여주기 위한 스냅샷
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
//        let entry = SimpleEntry(date: Date(), testString: "111")
        let entry = SimpleEntry(
            date: Date(),
            day: "111",
            time: "111",
            location: "동도옫ㅇ",
            icon: "01d",
            description: "111",
            temp: 0.01,
            tempMin: 0.01,
            tempMax: 0.01
        )
        
        completion(entry)
    }
    
    // 위젯 새로고침 스케쥴
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        let data = DataManager.shared.retrieve()
        
        let currentDate = Date()
        for hourOffset in 0 ..< 24 {
            let entryDate = Calendar.current.date(byAdding: .second, value: hourOffset * 3, to: currentDate)!
//            let entry = SimpleEntry(date: entryDate, testString: "\(hourOffset * 3)")
            var entry = data[hourOffset].toEntry
            entry.date = entryDate
            
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
//    let date: Date
//    var testString: String
    
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
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct TUWidget_Previews: PreviewProvider {
    static var previews: some View {
        let entry = SimpleEntry(
            date: Date(),
            day: "333",
            time: "333",
            location: "동도옫ㅇ",
            icon: "01d",
            description: "333",
            temp: 0.01,
            tempMin: 0.01,
            tempMax: 0.01
        )
        
        TUWidgetEntryView(entry: entry)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
