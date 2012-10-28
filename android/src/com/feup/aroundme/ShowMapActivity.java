package com.feup.aroundme;

import com.feup.aroundme.R;

import android.os.Bundle;

public class ShowMapActivity extends SuperActivity 
{

protected void onCreate(Bundle savedInstanceState) 
{
    super.onCreate(savedInstanceState);
    setContentView (R.layout.activity_show_map);
    setTitleFromActivityLabel (R.id.title_text);
}
    
} // end class
