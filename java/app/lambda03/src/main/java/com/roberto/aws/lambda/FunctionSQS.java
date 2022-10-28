package com.roberto.aws.lambda;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.SQSEvent;
import com.amazonaws.services.lambda.runtime.events.SQSEvent.SQSMessage;

import com.amazonaws.services.sqs.AmazonSQS;
import com.amazonaws.services.sqs.AmazonSQSClientBuilder;
import com.amazonaws.services.sqs.model.AmazonSQSException;
import com.amazonaws.services.sqs.model.Message;
import com.amazonaws.services.sqs.model.SendMessageRequest;
import com.amazonaws.services.sqs.model.SendMessageResult;

public class FunctionSQS implements RequestHandler<String, String> {

    private static final String QUEUE_NAME = "dlq-lambda-03";
    private AmazonSQS sqs = AmazonSQSClientBuilder.defaultClient();

    @Override
    public String handleRequest(String inMessage, Context context) {
        context.getLogger().log("Message received in lambda: " + inMessage);
        if (inMessage.contains("Error")) {
            context.getLogger().log("Sending message to DLQ: " + inMessage);
            SendMessageResult result = sendToDLQ("Message from lambda03: " + inMessage);
            context.getLogger().log("SendMessageResult " + result.getMessageId());
        }
        return "Success";
    }

    private SendMessageResult sendToDLQ(String message) {
        String queueUrl = sqs.getQueueUrl(QUEUE_NAME).getQueueUrl();

        SendMessageRequest send_msg_request = new SendMessageRequest()
                .withQueueUrl(queueUrl)
                .withMessageBody(message)
                .withDelaySeconds(5);
        SendMessageResult result = sqs.sendMessage(send_msg_request);
        return result;
    }
}

