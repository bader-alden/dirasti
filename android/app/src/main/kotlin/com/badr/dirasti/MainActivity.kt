package com.badr.dirasti

import io.flutter.embedding.android.FlutterActivity
import android.app.AlarmManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.widget.Button
import android.widget.TimePicker
import android.widget.Toast
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.*
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.graphics.BitmapFactory
import android.graphics.Color
import android.widget.RemoteViews
import androidx.annotation.RequiresApi

class MainActivity: FlutterActivity() {
    private val CHANNEL = "samples.flutter.dev/battery"

    @RequiresApi(Build.VERSION_CODES.M)
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            println(call.method)
            if (call.method == "add") {
                val text = call.argument<String>("text")
                val hour = call.argument<String>("hour")
                val min = call.argument<String>("min")
                val year = call.argument<String>("year")
                val month = call.argument<String>("month")
                val day = call.argument<String>("day")
                title = "KotlinApp"
                println( "Alarm set set")
                val calendar: Calendar = Calendar.getInstance()
                    calendar.set(
                        Integer.parseInt(year),
                        Integer.parseInt(month),
                        Integer.parseInt(day)+1,
                        Integer.parseInt(hour),
                        Integer.parseInt(min),
                        0
                    )

                println(calendar.time);
                println(calendar.timeInMillis);
                if (text != null) {
                    setAlarm(calendar.timeInMillis,text)
                }

            }
        }

        }

    @RequiresApi(Build.VERSION_CODES.M)
    private fun setAlarm(timeInMillis: Long,text : String) {
        val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
        //val intent = Intent(this, MyAlarm::class.java)
        val intent = Intent(context, AlarmReceiver::class.java).apply {
            putExtra("EXTRA_MESSAGE", text)
        }
        val pendingIntent = PendingIntent.getBroadcast(this, 0, intent, PendingIntent.FLAG_NO_CREATE)
//        alarmManager.setRepeating(
//            AlarmManager.RTC,
//            timeInMillis,
//            AlarmManager.INTERVAL_DAY,
//            pendingIntent
//        )
        alarmManager.setExactAndAllowWhileIdle(
            AlarmManager.RTC_WAKEUP,
            timeInMillis,
            PendingIntent.getBroadcast(
                context,
                text.hashCode(),
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
        )
        Log.d("Alarm Bell", "Alarm just scss")
        println( "Alarm scss scss")
       // println(Date());
        Toast.makeText(this, "تمت إضافة التنبيه", Toast.LENGTH_SHORT).show()
    }    }