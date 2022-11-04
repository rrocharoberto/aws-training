package com.roberto.aws.lambda;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class FunctionHello implements RequestHandler<String, String> {
    
    private static final Logger logger = LoggerFactory.getLogger(FunctionHello.class);

    @Override
    public String handleRequest(String inMessage, Context context) {
        context.getLogger().log("Message received in lambda: " + inMessage);

        logger.info("slf4j logger ok.");

        return "Hello " + inMessage + " from " + context.getFunctionName();
    }
}
