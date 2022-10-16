package com.roberto.aws.lambda;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;

public class FunctionHello implements RequestHandler<String, String> {
    
    @Override
    public String handleRequest(String inMessage, Context context) {
        context.getLogger().log("Message received in lambda: " + inMessage);

        return "Hello " + inMessage + " from " + context.getFunctionName();
    }
}
