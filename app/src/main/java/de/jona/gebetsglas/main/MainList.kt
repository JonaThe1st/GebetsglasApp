package de.jona.gebetsglas.main

import android.app.Activity
import android.content.Context
import android.view.View
import android.view.ViewGroup
import android.widget.ArrayAdapter
import android.widget.TextView
import android.widget.Toast
import androidx.core.view.isVisible
import de.jona.gebetsglas.R

class MainList: ArrayAdapter<String> {

    val resource: Int
    val text: ArrayList<String>
    val context: Activity

    constructor(context: Activity, resource: Int, text: ArrayList<String>): super(context, resource, text) {
        this.resource = resource
        this.text = text
        this.context = context
    }

    override fun getView(position: Int, convertView: View?, parent: ViewGroup): View {

        val inflater = context.layoutInflater
        val rowView = inflater.inflate(resource, null, true)

        val mainText: TextView = rowView.findViewById(R.id.list_element_main)
        val subText: TextView = rowView.findViewById(R.id.list_element_sub)

        val sharedPref = context.getSharedPreferences(context.getString(R.string.preference_file_key), Context.MODE_PRIVATE)
        val dailyIssue = sharedPref.getString(context.getString(R.string.preferene_category_random, text[position]), null)
        subText.isVisible = dailyIssue != null

        subText.setText("Heutiges anliegen: ${dailyIssue}")
        mainText.setText(text[position])

        return rowView
    }

}