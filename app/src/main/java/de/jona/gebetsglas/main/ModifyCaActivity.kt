package de.jona.gebetsglas.main

import androidx.appcompat.app.AppCompatActivity

abstract class ModifyCaActivity: AppCompatActivity(){

    abstract val categories: ArrayList<String>

    abstract fun display()

}