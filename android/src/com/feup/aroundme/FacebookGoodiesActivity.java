package com.feup.aroundme;

import com.feup.aroundme.R;

import android.os.Bundle;

public class FacebookGoodiesActivity extends SuperActivity 
{

protected void onCreate(Bundle savedInstanceState) 
{
    super.onCreate(savedInstanceState);
    setContentView (R.layout.activity_facebook_goodies);
    setTitleFromActivityLabel (R.id.title_text);
}
    
} // end class
