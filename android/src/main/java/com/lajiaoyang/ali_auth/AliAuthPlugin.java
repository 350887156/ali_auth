/*
 * @Author: your name
 * @Date: 2021-05-12 17:29:01
 * @LastEditTime: 2021-05-24 17:32:32
 * @LastEditors: Sclea
 * @Description: In User Settings Edit
 * @FilePath: /ali_auth/android/src/main/java/com/lajiaoyang/ali_auth/AliAuthPlugin.java
 */
package com.lajiaoyang.ali_auth;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.os.Build;
import android.view.Surface;
import android.view.View;
import android.widget.Toast;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.plugin.common.StandardMessageCodec;

import com.alibaba.fastjson.JSON;
import com.mobile.auth.gatewayauth.AuthRegisterViewConfig;
import com.mobile.auth.gatewayauth.AuthRegisterXmlConfig;
import com.mobile.auth.gatewayauth.AuthUIConfig;
import com.mobile.auth.gatewayauth.AuthUIControlClickListener;
import com.mobile.auth.gatewayauth.CustomInterface;
import com.mobile.auth.gatewayauth.PhoneNumberAuthHelper;
import com.mobile.auth.gatewayauth.PreLoginResultListener;
import com.mobile.auth.gatewayauth.TokenResultListener;
import com.mobile.auth.gatewayauth.model.TokenRet;
import com.mobile.auth.gatewayauth.ui.AbstractPnsViewDelegate;
import com.nirvana.tools.core.AppUtils;
import com.lajiaoyang.ali_auth.CustomUIUtils;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * AliAuthPlugin
 */
public class AliAuthPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {

    private MethodChannel channel;
    private PhoneNumberAuthHelper authHelper;
    //  private TokenResultListener mTokenListener;
    private static Activity mActivity;
    private static Context mContext;
    private int mScreenWidthDp;
    private int mScreenHeightDp;
    private FlutterAssets flutterAssets;


    //  @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "com.lajiaoyang.ali_auth");
        channel.setMethodCallHandler(this);
        mContext = flutterPluginBinding.getApplicationContext();
        flutterAssets = flutterPluginBinding.getFlutterAssets();
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (!call.method.equals("init") && authHelper == null) {
            Map<String,String>  jsonObject = new  HashMap<String,String>();
            jsonObject.put("code", "70001");
            jsonObject.put("msg", "SDK????????????");
            jsonObject.put("method", call.method);
            channel.invokeMethod("callBack", jsonObject);
            return;
        }
        switch (call.method) {
            case "init": {

                authHelper = PhoneNumberAuthHelper.getInstance(mContext, null);
                Map<String,String>  jsonObject = new  HashMap<String,String>();
                try {
                    String appKey = call.argument("appKey");
                    authHelper.setAuthSDKInfo(appKey);
                    jsonObject.put("code", "0");
                    jsonObject.put("msg", "SDK???????????????");
                    jsonObject.put("method", "init");

                } catch (Exception e) {
                    jsonObject.put("code", "700000");
                    jsonObject.put("msg", "SDK???????????????");
                    jsonObject.put("method", "init");
                }
                channel.invokeMethod("callBack", jsonObject);
            }
            break;
            case "pre":
                PreLoginResultListener preLoginResultListener = new PreLoginResultListener() {
                    @Override
                    public void onTokenSuccess(final String vendor) {
                        mActivity.runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                Map<String,String>  jsonObject = new  HashMap<String,String>();
                                jsonObject.put("code", "0");
                                jsonObject.put("msg", "??????????????????????????????????????????");
                                jsonObject.put("method", "pre");
                                channel.invokeMethod("callBack", jsonObject);
                            }
                        });
                    }

                    @Override
                    public void onTokenFailed(final String vendor, final String ret) {
                        mActivity.runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                Map<String,String>  jsonObject = new  HashMap<String,String>();
                                jsonObject.put("code", ret);
                                jsonObject.put("msg", "???????????????????????????????????????!");
                                jsonObject.put("method", "pre");
                                channel.invokeMethod("callBack", jsonObject);
                            }
                        });
                    }

                };
                authHelper.accelerateLoginPage(5000, preLoginResultListener);
                break;
            case "login":
                TokenResultListener tokenResultListener = new TokenResultListener() {
                    @Override
                    public void onTokenSuccess(final String s) {
                        mActivity.runOnUiThread(new Runnable() {

                            @Override
                            public void run() {
                                TokenRet tokenRet = null;
                                try {
                                    tokenRet = JSON.parseObject(s, TokenRet.class);
                                } catch (Exception e) {
                                    e.printStackTrace();
                                }
                                resultData("login", tokenRet);
                            }
                        });
                    }

                    @Override
                    public void onTokenFailed(final String s) {
                        mActivity.runOnUiThread(new Runnable() {

                            @Override
                            public void run() {
                                TokenRet tokenRet = null;
                                try {
                                    tokenRet = JSON.parseObject(s, TokenRet.class);
                                } catch (Exception e) {
                                    e.printStackTrace();
                                }
                                resultData("login", tokenRet);
                            }
                        });
                    }
                };
                authHelper.setAuthListener(tokenResultListener);
                login(call);
                break;

            case "checkEnvAvailable": {
                TokenResultListener listener = new TokenResultListener() {
                    @Override
                    public void onTokenSuccess(final String s) {
                        mActivity.runOnUiThread(new Runnable() {

                            @Override
                            public void run() {
                                TokenRet tokenRet = null;
                                try {
                                    tokenRet = JSON.parseObject(s, TokenRet.class);
                                } catch (Exception e) {
                                    e.printStackTrace();
                                }
                                resultData("checkEnvAvailable", tokenRet);
                            }
                        });
                    }

                    @Override
                    public void onTokenFailed(final String s) {
                        mActivity.runOnUiThread(new Runnable() {

                            @Override
                            public void run() {
                                TokenRet tokenRet = null;
                                try {
                                    tokenRet = JSON.parseObject(s, TokenRet.class);
                                } catch (Exception e) {
                                    e.printStackTrace();
                                }
                                resultData("checkEnvAvailable", tokenRet);
                            }
                        });
                    }
                };
                authHelper.setAuthListener(listener);
                authHelper.checkEnvAvailable(2);
            }
            break;
            case "accelerateVerify": {
                PreLoginResultListener preListener = new PreLoginResultListener() {
                    @Override
                    public void onTokenSuccess(final String vendor) {
                        mActivity.runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                Map<String,String>  jsonObject = new  HashMap<String,String>();
                                jsonObject.put("code", "0");
                                jsonObject.put("msg", "?????????????????????????????????");
                                jsonObject.put("method", "accelerateVerify");
                                channel.invokeMethod("callBack", jsonObject);
                            }
                        });
                    }

                    @Override
                    public void onTokenFailed(final String vendor, String errorMsg) {
                        mActivity.runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                Map<String,String>  jsonObject = new  HashMap<String,String>();
                                jsonObject.put("code", "700000");
                                jsonObject.put("msg", "?????????????????????????????????");
                                jsonObject.put("method", "accelerateVerify");
                                channel.invokeMethod("callBack", jsonObject);
                            }
                        });
                    }
                };
                authHelper.accelerateVerify(5000, preListener);
            }
            break;
            case "cancelLogin": {
                authHelper.quitLoginPage();
                Map<String,String>  jsonObject = new  HashMap<String,String>();
                jsonObject.put("code", "0");
                jsonObject.put("msg", "?????????????????????");
                jsonObject.put("method", "cancelLogin");
                channel.invokeMethod("callBack", jsonObject);

            }
            break;
            case "getCurrentCarrierName": {
                String name = authHelper.getCurrentCarrierName();
                Map<String,String>  jsonObject = new  HashMap<String,String>();
                if (name == null) {
                    jsonObject.put("code", "600004");
                    jsonObject.put("msg", "?????????????????????????????????");
                    jsonObject.put("method", "getCurrentCarrierName");
                } else {
                    jsonObject.put("code", "0");
                    jsonObject.put("name", name);
                    jsonObject.put("msg", "?????????????????????????????????");
                    jsonObject.put("method", "getCurrentCarrierName");
                }

                channel.invokeMethod("callBack", jsonObject);
            }
            break;

        }
    }

    private void login(@NonNull MethodCall call) {
        mActivity.overridePendingTransition(0, 0);
        Map uiConfig = (Map) call.argument("UIConfig");
        ArrayList<String> privacy = (ArrayList<String>) uiConfig.get("privacy");
        authHelper.removeAuthRegisterXmlConfig();
        authHelper.removeAuthRegisterViewConfig();
        int authPageOrientation = ActivityInfo.SCREEN_ORIENTATION_SENSOR_PORTRAIT;
        if (Build.VERSION.SDK_INT == 26) {
            authPageOrientation = ActivityInfo.SCREEN_ORIENTATION_BEHIND;
        }
        updateScreenSize(authPageOrientation);
        int dialogWidth = (int) (mScreenWidthDp * 0.8f);
        int dialogHeight = (int) (mScreenHeightDp * 0.65f) - 50;
        int unit = dialogHeight / 10;
        int logBtnHeight = (int) (unit * 1.2);
        AuthUIConfig.Builder builder = new AuthUIConfig.Builder();
        // ??????????????????
        builder.setStatusBarColor(Color.parseColor("#ffffff"))
                .setAppPrivacyOne(privacy.get(0), privacy.get(1))
                .setWebViewStatusBarColor(Color.TRANSPARENT)
                .setNavHidden(true)
                .setSwitchAccHidden(true)
                .setPrivacyState(false)
                .setCheckboxHidden(true)
                .setLogoImgPath(flutterAssets.getAssetFilePathByName((String) uiConfig.get("logoImage")))
                .setLogoOffsetY(0)
                .setLogoWidth(42)
                .setLogBtnHeight(35)
                .setLogoHeight(42)
                .setNumFieldOffsetY(unit + 10)
                .setNumberSizeDp(17)
                .setPageBackgroundPath("dialog_page_background")
                .setSloganText("????????????????????????????????????????????????")
                .setSloganOffsetY(unit * 3)
                .setSloganTextSizeDp(11)

                .setLogBtnOffsetY(unit * 4)
                .setLogBtnHeight(logBtnHeight)
                .setLogBtnMarginLeftAndRight(30)
                .setLogBtnTextSizeDp(20)
                .setVendorPrivacyPrefix("???")
                .setVendorPrivacySuffix("???")
                .setDialogHeight(dialogHeight)
                .setDialogBottom(true)
                .setScreenOrientation(authPageOrientation);
        authHelper.setAuthUIConfig(builder.create());

        authHelper.getLoginToken(mContext, 5000);
    }

    private boolean dataStatus(Map data, String key) {
        if (data.containsKey(key) && data.get(key) != null) {
            if ((data.get(key) instanceof Float) || (data.get(key) instanceof Double) && (double) data.get(key) > -1) {
                return true;
            } else if ((data.get(key) instanceof Integer) || (data.get(key) instanceof Number) && (int) data.get(key) > -1) {
                return true;
            } else if ((data.get(key) instanceof Boolean) && (boolean) data.get(key)) {
                return true;
            } else if ((data.get(key) instanceof String) && !((String) data.get(key)).equals("")) {
                return true;
            } else {
                return false;
            }
        } else {
            return false;
        }
    }

    protected void updateScreenSize(int authPageScreenOrientation) {
        int screenHeightDp = CustomUIUtils.px2dp(mContext, CustomUIUtils.getPhoneHeightPixels(mContext));
        int screenWidthDp = CustomUIUtils.px2dp(mContext, CustomUIUtils.getPhoneWidthPixels(mContext));
        int rotation = mActivity.getWindowManager().getDefaultDisplay().getRotation();
        if (authPageScreenOrientation == ActivityInfo.SCREEN_ORIENTATION_BEHIND) {
            authPageScreenOrientation = mActivity.getRequestedOrientation();
        }
        if (authPageScreenOrientation == ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE
                || authPageScreenOrientation == ActivityInfo.SCREEN_ORIENTATION_SENSOR_LANDSCAPE
                || authPageScreenOrientation == ActivityInfo.SCREEN_ORIENTATION_USER_LANDSCAPE) {
            rotation = Surface.ROTATION_90;
        } else if (authPageScreenOrientation == ActivityInfo.SCREEN_ORIENTATION_PORTRAIT
                || authPageScreenOrientation == ActivityInfo.SCREEN_ORIENTATION_SENSOR_PORTRAIT
                || authPageScreenOrientation == ActivityInfo.SCREEN_ORIENTATION_USER_PORTRAIT) {
            rotation = Surface.ROTATION_180;
        }
        switch (rotation) {
            case Surface.ROTATION_0:
            case Surface.ROTATION_180:
                mScreenWidthDp = screenWidthDp;
                mScreenHeightDp = screenHeightDp;
                break;
            case Surface.ROTATION_90:
            case Surface.ROTATION_270:
                mScreenWidthDp = screenHeightDp;
                mScreenHeightDp = screenWidthDp;
                break;
            default:
                break;
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        mActivity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {

    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {

    }

    @Override
    public void onDetachedFromActivity() {

    }

    private void resultData(String method, TokenRet tokenRet) {
        Map<String,String>  jsonObject = new  HashMap<String,String>();
        jsonObject.put("code", tokenRet.getCode());
        jsonObject.put("method", method);
        switch (tokenRet.getCode()) {
            case "600000":
                String token = tokenRet.getToken();
                authHelper.quitLoginPage();
                jsonObject.put("code", tokenRet.getCode());
                jsonObject.put("msg", "??????token?????????");
                jsonObject.put("token", token);
                jsonObject.put("code", "0");

                break;
            case "600001":
                jsonObject.put("msg", "????????????????????????");
                jsonObject.put("code", "0");
                return;
            case "600002":
                jsonObject.put("msg", "?????????????????????????????????????????????????????????");
                break;
            case "600004":
                jsonObject.put("msg", "???????????????????????????????????????????????????????????????");
                break;
            case "600005":
                jsonObject.put("msg", "???????????????????????????????????????????????????");
                break;
            case "600007":
                jsonObject.put("msg", "????????????sim?????????????????? SIM ????????????");
                break;
            case "600008":
                jsonObject.put("msg", "?????????????????????????????????????????????????????????");
                break;
            case "600009":
                jsonObject.put("msg", "?????????????????????! ???????????????????????????");
                break;
            case "600010":
                jsonObject.put("msg", "??????????????????????????????????????????");
                break;
            case "600011":
                jsonObject.put("msg", "??????token????????????????????????????????????");
                break;
            case "600012":
                jsonObject.put("msg", "??????????????????");
                break;
            case "600013":
                jsonObject.put("msg", "?????????????????????????????????????????????????????????????????????");
                break;
            case "600014":
                jsonObject.put("msg", "?????????????????????????????????????????????????????????????????????????????????");
                break;
            case "600015":
                jsonObject.put("msg", "??????????????????????????????????????????");
                break;
            case "600017":
                jsonObject.put("msg", "AppID???Appkey????????????! ??????????????????????????????????????????????????????????????????????????????????????????????????????????????????");
                break;
            case "600021":
                jsonObject.put("msg", "?????????????????????????????????????????????????????????????????????????????????");
                break;
            case "600023":
                jsonObject.put("msg", "?????????????????????????????????????????????????????????????????????");
                break;
            case "600024":
                jsonObject.put("msg", "??????????????????????????????");
                jsonObject.put("code", "0");
                break;
            case "600025":
                jsonObject.put("msg", "?????????????????????????????????????????????????????????????????????");
                break;
            case "600026":
                jsonObject.put("msg", "?????????????????????????????????????????????????????????????????????????????????????????????????????????preLogin??????accelerateAuthPage??????????????????????????????");
                break;
            default:
                break;
        }

        channel.invokeMethod("callBack", jsonObject);
    }
}
