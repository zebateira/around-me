package com.feup.aroundme;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.net.MalformedURLException;

import com.facebook.android.AsyncFacebookRunner;
import com.facebook.android.AsyncFacebookRunner.RequestListener;
import com.facebook.android.Facebook;
import com.facebook.android.FacebookError;
import com.feup.aroundme.R;
import com.feup.aroundme.other.AppPreferences;

import android.content.SharedPreferences;
import android.os.Bundle;
import android.os.Handler;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.Toast;

public class SettingsFacebookActivity extends SuperActivity 
{
	Facebook facebook = new Facebook("360645504021378");
    AsyncFacebookRunner mAsyncRunner = new AsyncFacebookRunner(facebook);
    SharedPreferences mPrefs;
    private Handler mHandler = new Handler();

	protected void onCreate(Bundle savedInstanceState) 
	{
	    super.onCreate(savedInstanceState);
	    setContentView (R.layout.activity_facebook_settings);
	    setTitleFromActivityLabel (R.id.title_text);
	      
	    // Restore settings FB
	    mPrefs = this.getSharedPreferences("appPrefs", MODE_WORLD_READABLE);
	    String access_token = mPrefs.getString("access_token", null);
	    long expires = mPrefs.getLong("access_expires", (long) 0);
	    if(access_token != null) {
	        facebook.setAccessToken(access_token);
	    }
	    if(expires != 0) {
	        facebook.setAccessExpires(expires);
	    }
	    
	    Log.d("FACEBOOK", "token valid:" + facebook.isSessionValid() + " token:" + access_token );
	    
	    Button logOut = (Button) findViewById(R.id.btnLogOut);
	    logOut.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View arg0) {
				if (facebook.isSessionValid()) {
					Toast.makeText(SettingsFacebookActivity.this, "Terminando sessão..", Toast.LENGTH_LONG).show();
					AsyncFacebookRunner asyncRunner = new AsyncFacebookRunner(
							facebook);
					asyncRunner.logout(SettingsFacebookActivity.this.getApplicationContext(), new LogoutRequestListener()); // TODO watch out
					
				}
				else {
					Toast.makeText(SettingsFacebookActivity.this, "Não tem sessão activa.", Toast.LENGTH_LONG).show();
				}
			}
		});
	    
	    Button back = (Button) findViewById(R.id.btnBack);
	    back.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View arg0) {
				onClickFeature(arg0);
			}
			
		});   
	}

	private class LogoutRequestListener implements RequestListener {
	 
		public void onComplete(String response, Object state) {
			// Dispatch on its own thread
			mHandler.post(new Runnable() {
				public void run() {
					Toast.makeText(SettingsFacebookActivity.this, "Sessão terminada.", Toast.LENGTH_LONG).show();
					SharedPreferences.Editor editor = mPrefs.edit();
					editor.putString("access_token", facebook.getAccessToken());
                    editor.putLong("access_expires", facebook.getAccessExpires());
                    editor.commit();
				}
			});
		}
	 
		public void onIOException(IOException e, Object state) {
			// TODO Auto-generated method stub
	 
		}
	 
		public void onFileNotFoundException(FileNotFoundException e,
				Object state) {
			// TODO Auto-generated method stub
	 
		}
	 
		public void onMalformedURLException(MalformedURLException e,
				Object state) {
			// TODO Auto-generated method stub
	 
		}
	 
		public void onFacebookError(FacebookError e, Object state) {
			// TODO Auto-generated method stub
	 
		}
	}
    
} // end class
