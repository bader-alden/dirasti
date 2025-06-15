package com.badr.dirasti


import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.graphics.BitmapFactory
import android.graphics.Color
import android.os.Build
import androidx.core.content.ContextCompat.getSystemService


class AlarmReceiver: BroadcastReceiver() {
    lateinit var notificationManager: NotificationManager
    lateinit var notificationChannel: NotificationChannel
    lateinit var builder: Notification.Builder
    private val channelId = "i.apps.notifications"
    private val description = "Test notification"
    override fun onReceive(context: Context?, intent: Intent?) {


        context?.let {
            println("Alarm triggered: oooooooooooooooooooooooo")
            val message = intent?.getStringExtra("EXTRA_MESSAGE") ?: return
            notificationManager = it.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            val pendingIntent = PendingIntent.getActivity(it, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                notificationChannel = NotificationChannel(channelId, description, NotificationManager.IMPORTANCE_HIGH)
                notificationChannel.enableLights(true)
                notificationChannel.lightColor = Color.GREEN
                notificationChannel.enableVibration(false)
                notificationManager.createNotificationChannel(notificationChannel)
                builder = Notification.Builder(it, channelId)
                    // .setContent(contentView)
                    .setContentText(message)
                    .setSmallIcon(R.drawable.app_icon)
                    .setLargeIcon(BitmapFactory.decodeResource(it.resources, R.drawable.app_icon))
                    .setContentIntent(pendingIntent)
            } else {
                builder = Notification.Builder(it)
                    //.setContent("contentView")
                    .setContentText(message)
                    .setSmallIcon(R.drawable.app_icon)
                    .setLargeIcon(BitmapFactory.decodeResource(it.resources, R.drawable.app_icon))
                    .setContentIntent(pendingIntent)
            }
            notificationManager.notify(1234, builder.build())



        }


    }
}