package com.alexandrratush.ane;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;

public class CookieManagerExtension implements FREExtension {
    public static final String ERROR_EVENT = "error";

    private FREContext context;

    @Override
    public FREContext createContext(String extId) {
        return context = new CookieManagerContext();
    }

    @Override
    public void dispose() {
        if (context != null) context.dispose();
        context = null;
    }

    @Override
    public void initialize() {
        // TODO Auto-generated method stub
    }
}
