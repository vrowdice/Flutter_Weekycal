package com.example.weekycal

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.net.Uri
import android.util.Log
import android.view.View
import android.widget.RemoteViews
import androidx.annotation.NonNull
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider
import org.json.JSONArray
import org.json.JSONException

class AppWidgetProvider : HomeWidgetProvider() {

companion object {
    private const val SCHEDULE_DATA_KEY = "schedule_data"
    val TV_SCHEDULE_NAME_1 = R.id.tv_schedule_name_1
    val TV_SCHEDULE_TIME_1 = R.id.tv_schedule_time_1
    val TV_SCHEDULE_NAME_2 = R.id.tv_schedule_name_2
    val TV_SCHEDULE_TIME_2 = R.id.tv_schedule_time_2
    val TV_SCHEDULE_NAME_3 = R.id.tv_schedule_name_3
    val TV_SCHEDULE_TIME_3 = R.id.tv_schedule_time_3
    val TV_SCHEDULE_NAME_4 = R.id.tv_schedule_name_4
    val TV_SCHEDULE_TIME_4 = R.id.tv_schedule_time_4
    val TV_SCHEDULE_NAME_5 = R.id.tv_schedule_name_5
    val TV_SCHEDULE_TIME_5 = R.id.tv_schedule_time_5
    val TV_SCHEDULE_NAME_6 = R.id.tv_schedule_name_6
    val TV_SCHEDULE_TIME_6 = R.id.tv_schedule_time_6
    val TV_SCHEDULE_NAME_7 = R.id.tv_schedule_name_7
    val TV_SCHEDULE_TIME_7 = R.id.tv_schedule_time_7

}

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.widget_layout)

            // 앱 실행 버튼
            val pendingIntent = HomeWidgetLaunchIntent.getActivity(
                context,
                MainActivity::class.java
            )
            views.setOnClickPendingIntent(R.id.widget_root, pendingIntent)

            // 저장된 일정 데이터 가져오기
            val scheduleJson = widgetData.getString(SCHEDULE_DATA_KEY, "[]") ?: "[]"
            val weekList = parseScheduleData(scheduleJson)
            Log.d("AppWidgetProvider", "Retrieved JSON: $scheduleJson")

            // 주별로 첫 번째 주의 일정만 표시 (7일의 일정)
            for (dayIndex in 0 until 7) {
                val daySchedule = weekList.getOrNull(dayIndex)
                // 일정이 있을 경우 텍스트 설정
                if (daySchedule != null) {
                    views.setTextViewText(getScheduleNameViewId(dayIndex), daySchedule.name)
                    views.setTextViewText(getScheduleTimeViewId(dayIndex), "${daySchedule.startTime} ~ ${daySchedule.endTime}")
                    views.setViewVisibility(getScheduleNameViewId(dayIndex), View.VISIBLE)
                    views.setViewVisibility(getScheduleTimeViewId(dayIndex), View.VISIBLE)
                } else {
                    // 일정이 없으면 숨기기
                    views.setViewVisibility(getScheduleNameViewId(dayIndex), View.GONE)
                    views.setViewVisibility(getScheduleTimeViewId(dayIndex), View.GONE)
                }
            }

            // 새로고침 버튼
            val refreshIntent = HomeWidgetBackgroundIntent.getBroadcast(
                context,
                Uri.parse("myAppWidget://refreshSchedule")
            )
            views.setOnClickPendingIntent(R.id.bt_update, refreshIntent)

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)

        if (intent.data?.toString() == "myAppWidget://refreshSchedule") {
            Log.d("AppWidgetProvider", "Refreshing widget...") // 추가
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
        try {
            val jsonArray = JSONArray(jsonString)

            for (i in 0 until jsonArray.length()) {
                val jsonObject = jsonArray.getJSONObject(i)

                // scheduleInfo 내부 배열을 가져와서 일정 리스트로 변환
                val scheduleInfoArray = jsonObject.getJSONArray("scheduleInfo")
                for (j in 0 until scheduleInfoArray.length()) {
                    val scheduleInfo = scheduleInfoArray.getJSONObject(j)
                    val schedule = ScheduleData(
                        scheduleInfo.getString("name"),
                        scheduleInfo.getInt("startTime"),
                        scheduleInfo.getInt("endTime")
                    )
                    scheduleList.add(schedule)
                }
            }
        } catch (e: JSONException) {
            Log.e("AppWidgetProvider", "Error parsing JSON: ${e.message}")
            // Handle the error appropriately, e.g., return an empty list or display an error message
        }
        return scheduleList
    }

    // 일정 데이터 클래스
    data class ScheduleData(
        val name: String,
        val startTime: Int,
        val endTime: Int
    )

    // 일정 이름을 표시할 TextView의 ID를 가져오는 함수
    private fun getScheduleNameViewId(index: Int): Int {
        return when (index) {
            0 -> TV_SCHEDULE_NAME_1
            1 -> TV_SCHEDULE_NAME_2
            2 -> TV_SCHEDULE_NAME_3
            3 -> TV_SCHEDULE_NAME_4
            4 -> TV_SCHEDULE_NAME_5
            5 -> TV_SCHEDULE_NAME_6
            else -> TV_SCHEDULE_NAME_7
        }
    }

    // 일정 시간을 표시할 TextView의 ID를 가져오는 함수
    private fun getScheduleTimeViewId(index: Int): Int {
        return when (index) {
            0 -> TV_SCHEDULE_TIME_1
            1 -> TV_SCHEDULE_TIME_2
            2 -> TV_SCHEDULE_TIME_3
            3 -> TV_SCHEDULE_TIME_4
            4 -> TV_SCHEDULE_TIME_5
            5 -> TV_SCHEDULE_TIME_6
            else -> TV_SCHEDULE_TIME_7
        }
    }
}