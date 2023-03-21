package com.roberto.aws.lambda;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.SQSEvent;
import com.amazonaws.services.lambda.runtime.events.SQSEvent.SQSMessage;
import com.roberto.aws.dynamodb.MessageRepository;
import com.roberto.aws.dynamodb.entity.MessageEntity;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class FunctionDLQConsumer implements RequestHandler<SQSEvent, String> {

  private static final Logger logger = LoggerFactory.getLogger(FunctionDLQConsumer.class);
  private MessageRepository repo = new MessageRepository();

  @Override
  public String handleRequest(SQSEvent event, Context context) {
    logger.info("Event received in Lambda: " + event);
    for (SQSMessage msg : event.getRecords()) {
      logger.info("Processing message: " + msg.getBody());

      MessageEntity message = 
        new MessageEntity(Long.toString(System.currentTimeMillis()), msg.getBody());
      repo.saveMessage(message);
    }
    return "SUCCESS";
  }
}
