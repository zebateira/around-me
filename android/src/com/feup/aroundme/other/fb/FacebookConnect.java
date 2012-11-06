package com.feup.aroundme.other.fb;

import android.app.Activity;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.util.Log;
import android.widget.Toast;

import com.facebook.android.*;
import com.facebook.android.Facebook.*;
import com.facebook.android.AsyncFacebookRunner;
import com.feup.aroundme.SettingsFacebookActivity;

public class FacebookConnect extends Activity {

    Facebook facebook = new Facebook("360645504021378");
    AsyncFacebookRunner mAsyncRunner = new AsyncFacebookRunner(facebook);
    private SharedPreferences mPrefs;
	private static final String[] PERMS = new String[] { "user_events", "friends_events" };

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
        /*
         * Get existing access_token if any
         */
        mPrefs = this.getSharedPreferences("appPrefs", MODE_WORLD_READABLE);
        String access_token = mPrefs.getString("access_token", null);
        long expires = mPrefs.getLong("access_expires", 0);
        if(access_token != null) {
            facebook.setAccessToken(access_token);
            Log.d("FACEBOOK", "YES token valid:" + facebook.isSessionValid() + " token:" + access_token );
        } else {Log.d("FACEBOOK", "NO token" + access_token);}
        if(expires != 0) {
            facebook.setAccessExpires(expires);
        }
        
        /*
         * Only call authorize if the access_token has expired.
         */
        if(!facebook.isSessionValid()) {

            facebook.authorize(this, PERMS, new DialogListener() {
                @Override
                public void onComplete(Bundle values) {
                    SharedPreferences.Editor editor = mPrefs.edit();
                    editor.putString("access_token", facebook.getAccessToken());
                    editor.putLong("access_expires", facebook.getAccessExpires());
                    editor.commit();
                    Toast.makeText(FacebookConnect.this, "Autenticação feita com sucesso.", Toast.LENGTH_LONG).show();
                    finish();
                }
    
                @Override
                public void onFacebookError(FacebookError error) {}
    
                @Override
                public void onError(DialogError e) {}
    
                @Override
                public void onCancel() {}
            });
        } else {
        	Toast.makeText(FacebookConnect.this, "Já existe uma sessão activa.", Toast.LENGTH_LONG).show();
        	finish();
        }
    }
    

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        facebook.authorizeCallback(requestCode, resultCode, data);
    }
}