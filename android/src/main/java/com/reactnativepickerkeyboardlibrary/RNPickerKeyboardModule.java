package com.reactnativepickerkeyboardlibrary;

import android.widget.Toast;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;

public class RNPickerKeyboardModule extends ReactContextBaseJavaModule {

    private final ReactApplicationContext reactContext;

    public RNPickerKeyboardModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    @Override
    public String getName() {
        return "RNPickerKeyboard";
    }

    @ReactMethod
    public void show(String text) {
        Toast.makeText(this.reactContext, text, Toast.LENGTH_LONG).show();
    }
}
