package com.roberto.aws.lambda;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.sqs.AmazonSQS;
import com.amazonaws.services.sqs.AmazonSQSClientBuilder;
import com.amazonaws.services.sqs.model.SendMessageRequest;
import com.amazonaws.services.sqs.model.SendMessageResult;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class FunctionSQSProducer implements RequestHandler<String, String> {

    private static final Logger logger = LoggerFactory.getLogger(FunctionSQSProducer.class);
    private static final String QUEUE_NAME = "hello-aws-training-queue";
    private AmazonSQS sqs = AmazonSQSClientBuilder.defaultClient();

    @Override
    public String handleRequest(String inMessage, Context context) {
        logger.info("Message received: " + inMessage);
        logger.info("Sending message to Queue " + QUEUE_NAME);
        String queueUrl = sqs.getQueueUrl(QUEUE_NAME).getQueueUrl();

        SendMessageRequest sendMsgRequest = new SendMessageRequest()
            .withQueueUrl(queueUrl)
            .withMessageBody("Message from lambda03: " + inMessage)
            .withDelaySeconds(1);
        SendMessageResult result = sqs.sendMessage(sendMsgRequest);
        logger.info("SendMessageResult " + result.getMessageId());
        return "Success";
    }
}
