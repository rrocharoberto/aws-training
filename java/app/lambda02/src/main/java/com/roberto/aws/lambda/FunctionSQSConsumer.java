package com.roberto.aws.lambda;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.SQSEvent;
import com.amazonaws.services.lambda.runtime.events.SQSEvent.SQSMessage;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class FunctionSQSConsumer implements RequestHandler<SQSEvent, String> {

    private static final Logger logger = LoggerFactory.getLogger(FunctionSQSConsumer.class);

    @Override
    public String handleRequest(SQSEvent event, Context context) {
        logger.info("Event received: " + event);
        for (SQSMessage msg : event.getRecords()) {
            logger.info("Event body " + new String(msg.getBody()));

            // Checks if the message should raise an error -> send to DLQ
            if (msg.getBody().contains("Error")) {
                logger.info("Raising error. This will send the message to DLQ.");
                throw new RuntimeException("Invalid message input.");
            }
        }
        return "SUCCESS";
    }
}
