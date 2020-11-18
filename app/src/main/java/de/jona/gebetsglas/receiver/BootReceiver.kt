package de.jona.gebetsglas.receiver

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import de.jona.gebetsglas.R
import java.util.*

class BootReceiver: BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent?) {

        val sharedPref = context.getSharedPreferences(
            context.getString(R.string.preference_file_key),
            Context.MODE_PRIVATE)

        if (sharedPref.getBoolean(context.getString(R.string.preference_notification_enabled), false)) {

            val alarmManager: AlarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager

            val alarmHour = sharedPref.getInt(context.getString(R.string.preference_notification_hour), 12)
            val alarmMin = sharedPref.getInt(context.getString(R.string.preference_notification_min), 0)

            val pendingIntent: PendingIntent =
                PendingIntent.getBroadcast(context, 0, Intent(context, NotificationSender::class.java), 0)

            //set calendar to prefered date
            val c: Calendar = Calendar.getInstance()
            c.set(Calendar.HOUR_OF_DAY, alarmHour)
            c.set(Calendar.MINUTE, alarmMin)

            //if alarm was before now
            var triggerAt = c.timeInMillis
            if (triggerAt < System.currentTimeMillis()) {
                triggerAt += AlarmManager.INTERVAL_DAY
            }


            //set repeating alarm
            alarmManager.setInexactRepeating(
                AlarmManager.RTC,
                triggerAt,
                AlarmManager.INTERVAL_DAY,
                pendingIntent
            )


        }

    }

}