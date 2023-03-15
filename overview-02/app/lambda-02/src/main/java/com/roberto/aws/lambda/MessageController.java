package com.roberto.aws.lambda;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.APIGatewayProxyRequestEvent;
import com.amazonaws.services.lambda.runtime.events.APIGatewayProxyResponseEvent;
import com.amazonaws.util.StringUtils;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.roberto.aws.service.MessageService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class MessageController implements RequestHandler<APIGatewayProxyRequestEvent, APIGatewayProxyResponseEvent> {

  static final Logger logger = LoggerFactory.getLogger(MessageController.class);
  private MessageService service = new MessageService();
  private Gson gson = new GsonBuilder().setPrettyPrinting().create();

  @Override
  public APIGatewayProxyResponseEvent handleRequest(APIGatewayProxyRequestEvent input, Context context) {
    logger.info("Event received in Lambda: {}", input);

    String result = null;
    int statusCode = 200;

    try {
      switch (input.getHttpMethod()) {
        case "GET":
          List<MessageDTO> messages = service.listMessages();
          result = gson.toJson(messages);
          break;
        case "POST":
          MessageDTO bodyInput = gson.fromJson(input.getBody(), MessageDTO.class);
          if(StringUtils.isNullOrEmpty(bodyInput.getMessageText())) {
            statusCode = 400;
            result = "Missing required field.";
          } else {
            result = service.saveMessage(bodyInput);
          }
        break;
        default:
          result = "Operation not allowed: " + input.getHttpMethod();
          statusCode = 405;
      }
  } catch(Exception e) {
      logger.error("Error processing request: ", e);
      throw new RuntimeException("Error processing request");
    }
    return prepareResponse(result, statusCode);
  }

  private APIGatewayProxyResponseEvent prepareResponse(String result, int statusCode) {
    logger.info("Response status: {} result:{}", statusCode, result);
    Map<String, String> responseHeaders = new HashMap<>();
    responseHeaders.put("Content-Type", "application/json");
    APIGatewayProxyResponseEvent response = new APIGatewayProxyResponseEvent().withHeaders(responseHeaders);

    return response
        .withStatusCode(statusCode)
        .withBody(gson.toJson(new Error(statusCode, result)));
  }
}
