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
        SimpleEntry(date: Date(), testString: "000")
    }
    
    // 위젯 갤러리에서 보여주기 위한 스냅샷
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), testString: "111")
        completion(entry)
    }
    
    // 위젯 새로고침 스케쥴
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        let currentDate = Date()
        for hourOffset in 0 ..< 24 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: hourOffset * 3, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, testString: "\(hourOffset * 3)")
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    var testString: String
}

struct TUWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        ZStack {
            Image("01d")
            
            VStack {
                Text("5.24 (수) 21:00")
                    .font(UIFont.setCustomFont(font: .medium, size: 14))
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top)
                    .padding(.horizontal)
                
                HStack {
                    Text("상하동")
                        .font(UIFont.setCustomFont(font: .regular, size: 16))
                    
                    Text("맑음")
                        .font(UIFont.setCustomFont(font: .regular, size: 16))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                
                Text("-99.9°")
                    .font(UIFont.setCustomFont(font: .black, size: 32))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                Spacer()
                
                HStack {
                    Text("⤒ 99.9°")
                        .font(UIFont.setCustomFont(font: .regular, size: 18))
                        .padding(.leading)
                    
                    Spacer()
                    
                    Text("⤓ -11.0°")
                        .font(UIFont.setCustomFont(font: .regular, size: 18))
                        .padding(.trailing)
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom)
            }
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
        TUWidgetEntryView(entry: SimpleEntry(date: Date(), testString: "333"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
