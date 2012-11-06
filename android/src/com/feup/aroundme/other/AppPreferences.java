package com.feup.aroundme.other;

import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;

public class AppPreferences {
     private static final String APP_SHARED_PREFS = "com.feup.aroundme.settings_saved"; //  Name of the file -.xml
     private SharedPreferences appSharedPrefs;
     private Editor prefsEditor;

     public AppPreferences(Context context)
     {
         this.appSharedPrefs = context.getSharedPreferences(APP_SHARED_PREFS, Activity.MODE_PRIVATE);
         this.prefsEditor = appSharedPrefs.edit();
     }

     public String getString(String name) {
         return appSharedPrefs.getString(name, null);
     }
     
     public long getLong(String name, Long other) {
         return appSharedPrefs.getLong(name, other);
     }

     public void saveString(String name, String text) {
         prefsEditor.putString(name, text);
         prefsEditor.commit();
     }
     
     public void saveLong(String name, Long num) {
         prefsEditor.putLong(name, num);
         prefsEditor.commit();
     }
}