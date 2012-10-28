package com.feup.aroundme;

import com.feup.aroundme.R;

import android.os.Bundle;

public class EventsFacebookListActivity extends SuperActivity 
{

protected void onCreate(Bundle savedInstanceState) 
{
    super.onCreate(savedInstanceState);
    setContentView (R.layout.events_facebook_list);
    setTitleFromActivityLabel (R.id.title_text);
    
    // Receive List selected
    // Import events from FB->List selected
    // Fill checkbox
}
    
} // end class
