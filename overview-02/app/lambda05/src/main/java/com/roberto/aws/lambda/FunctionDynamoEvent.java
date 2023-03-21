package com.roberto.aws.lambda;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.LambdaLogger;
import com.amazonaws.services.lambda.runtime.events.DynamodbEvent;
import com.amazonaws.services.lambda.runtime.events.DynamodbEvent.DynamodbStreamRecord;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class FunctionDynamoEvent implements RequestHandler<DynamodbEvent, String> {

    private static final Logger logger = LoggerFactory.getLogger(FunctionDynamoEvent.class);
    private Gson gson = new GsonBuilder().setPrettyPrinting().create();

    @Override
    public String handleRequest(DynamodbEvent event, Context context) {
      logger.info("Amount of records: " + event.getRecords().size());
      for (DynamodbStreamRecord record : event.getRecords()){
        logger.info("Event id: " + record.getEventID()
            + " Name: " + record.getEventName()
            + " Info: " + record.getDynamodb().toString());
      }
      logEnvironment(event, context, gson);
      return "SUCCESS";
    }
    
    public static void logEnvironment(Object event, Context context, Gson gson) {
      LambdaLogger logger = context.getLogger();
      // log execution details
      logger.log("ENVIRONMENT VARIABLES: " + gson.toJson(System.getenv()));
      logger.log("CONTEXT: " + gson.toJson(context));
      // log event details
      logger.log("EVENT: " + gson.toJson(event));
      logger.log("EVENT TYPE: " + event.getClass().toString());
    }
  }
