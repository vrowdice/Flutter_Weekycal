package com.example.weekycal

import android.util.Log
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider
import com.example.weekycal.R
import com.example.weekycal.MainActivity
import org.json.JSONArray
import org.json.JSONObject

class AppWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.widget_layout).apply {

                // 앱 실행 버튼
                val pendingIntent = HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java
                )
                setOnClickPendingIntent(R.id.widget_root, pendingIntent)

                // 저장된 일정 데이터 가져오기
                val scheduleJson = widgetData.getString("schedule_data", "[]") ?: "[]"
                val scheduleList = parseScheduleData(scheduleJson)

                Log.d("AppWidgetProvider", "Schedule JSON: $scheduleJson")

                // 첫 번째 일정 표시
                if (scheduleList.isNotEmpty()) {
                    val schedule = scheduleList[0]
                    setTextViewText(R.id.tv_schedule_name, schedule.name)
                    setTextViewText(R.id.tv_schedule_time, "${schedule.startTime} ~ ${schedule.endTime}")
                } else {
                    setTextViewText(R.id.tv_schedule_name, "No schedule")
                    setTextViewText(R.id.tv_schedule_time, "-")
                }

                // 새로고침 버튼
                val refreshIntent = HomeWidgetBackgroundIntent.getBroadcast(
                    context,
                    Uri.parse("myAppWidget://refreshSchedule")
                )
                setOnClickPendingIntent(R.id.bt_update, refreshIntent)
            }

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }

    override fun onReceive(context: Context, intent: android.content.Intent) {
        super.onReceive(context, intent)

        if (intent.data?.toString() == "myAppWidget://refreshSchedule") {
            // 위젯 업데이트 요청
            val appWidgetManager = AppWidgetManager.getInstance(context)
            val widgetIds = appWidgetManager.getAppWidgetIds(
                android.content.ComponentName(context, AppWidgetProvider::class.java)
            )
            onUpdate(context, appWidgetManager, widgetIds, 
                context.getSharedPreferences("widget_data", Context.MODE_PRIVATE))
        }
    }

    // JSON 문자열을 ScheduleData 리스트로 변환
    private fun parseScheduleData(jsonString: String): List<ScheduleData> {
        val scheduleList = mutableListOf<ScheduleData>()
        val jsonArray = JSONArray(jsonString)

        for (i in 0 until jsonArray.length()) {
            val jsonObject = jsonArray.getJSONObject(i)
            val schedule = ScheduleData(
                jsonObject.getString("name"),
                jsonObject.getInt("startTime"),
                jsonObject.getInt("endTime")
            )
            scheduleList.add(schedule)
        }
        return scheduleList
    }

    // 일정 데이터 클래스
    data class ScheduleData(
        val name: String,
        val startTime: Int,
        val endTime: Int
    )
}
