package com.feup.aroundme;

import com.feup.aroundme.R;

import android.os.Bundle;

/**
 * This is the activity for feature 1 in the dashboard application.
 * It displays some text and provides a way to get back to the home activity.
 *
 */

public class EventDescriptionActivity extends DashboardActivity 
{

/**
 * onCreate
 *
 * Called when the activity is first created. 
 * This is where you should do all of your normal static set up: create views, bind data to lists, etc. 
 * This method also provides you with a Bundle containing the activity's previously frozen state, if there was one.
 * 
 * Always followed by onStart().
 *
 * @param savedInstanceState Bundle
 */

protected void onCreate(Bundle savedInstanceState) 
{
    super.onCreate(savedInstanceState);
    setContentView (R.layout.activity_event_description);
    setTitleFromActivityLabel (R.id.title_text);
}
    
} // end class
