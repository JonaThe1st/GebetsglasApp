package de.jona.gebetsglas.category

import android.app.Activity
import android.view.View
import android.view.ViewGroup
import android.widget.ArrayAdapter
import android.widget.CheckBox
import de.jona.gebetsglas.R

class CheckBoxList: ArrayAdapter<String> {

    val context: Activity
    val resource: Int
    val text: ArrayList<String>
    val checked: BooleanArray


    constructor(context: Activity, resource: Int, text: ArrayList<String>): super(context, resource, text) {
        this.context = context
        this.resource = resource
        this.text = text
        checked = BooleanArray(text.size)
    }

    override fun getView(position: Int, convertView: View?, parent: ViewGroup): View {

        val inflater = context.layoutInflater
        val rowView = inflater.inflate(resource, null, true)

        val checkBox: CheckBox = rowView.findViewById(R.id.checkBox)

        checkBox.setText(text[position])

        checkBox.setOnCheckedChangeListener { buttonView, isChecked ->
            checked[position] = !checked[position]
        }

        return rowView
    }

    fun getChecked(): Array<String> {
        val checkedFields: ArrayList<String> = ArrayList()
        for (i: Int in 0..text.size-1) {
           if (checked[i]) {
               checkedFields.add(text[i])
           }
        }
        return checkedFields.toArray(arrayOf())
    }
}

















