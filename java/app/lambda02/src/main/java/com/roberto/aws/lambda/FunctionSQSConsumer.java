package com.roberto.aws.lambda;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.SQSEvent;
import com.amazonaws.services.lambda.runtime.events.SQSEvent.SQSMessage;

public class FunctionSQSConsumer implements RequestHandler<SQSEvent, String> {

    @Override
    public String handleRequest(SQSEvent event, Context context) {
        context.getLogger().log("Event received in SQL Lambda: " + event);
        for (SQSMessage msg : event.getRecords()) {
            context.getLogger().log("Event body " + new String(msg.getBody()));

            // Checks if the message should raise an error -> send to DLQ
            if (msg.getBody().contains("Error")) {
                context.getLogger().log("Raising error. This will send the message to DLQ");
                throw new RuntimeException("Invalid message input.");
            }
        }
        return "SUCCESS";
    }
}
