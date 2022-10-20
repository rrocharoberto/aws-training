package com.roberto.aws.lambda;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.SQSEvent;
import com.amazonaws.services.lambda.runtime.events.SQSEvent.SQSMessage;

public class FunctionSQS implements RequestHandler<SQSEvent, Void>{

    @Override
    public Void handleRequest(SQSEvent event, Context context) {
        context.getLogger().log("Event received in SQL Lambda: " + event);
        for(SQSMessage msg : event.getRecords()){
            context.getLogger().log("Event body " + new String(msg.getBody()));
        }
        return null;
    }
}

