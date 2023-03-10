package com.roberto.aws.lambda;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.APIGatewayProxyRequestEvent;
import com.amazonaws.services.lambda.runtime.events.APIGatewayProxyResponseEvent;
import com.google.gson.Gson;
import com.roberto.aws.service.MessageService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class MessageController implements RequestHandler<APIGatewayProxyRequestEvent, APIGatewayProxyResponseEvent> {

  static final Logger logger = LoggerFactory.getLogger(MessageController.class);
  private MessageService service = new MessageService();

  @Override
  public APIGatewayProxyResponseEvent handleRequest(final APIGatewayProxyRequestEvent input, final Context context) {
    logger.info("Event received in Lambda: {}", input);

    Gson gson = new Gson();
    MessageDTO bodyInput = gson.fromJson(input.getBody(), MessageDTO.class);

    String result = null;
    int statusCode = 200;

    switch (input.getHttpMethod()) {
      case "GET":
        List<MessageDTO> messages = service.listMessages();
        result = gson.toJson(messages);
        break;
      case "POST":
        result = service.saveMessage(bodyInput);
        break;
      default:
        result = "Operation not allowed: " + input.getHttpMethod();
        statusCode = 400;
    }
    return prepareResponse(result, statusCode);
  }

  private APIGatewayProxyResponseEvent prepareResponse(String result, int statusCode) {
    String output = String.format("{ \"result\": %s }", result);

    Map<String, String> responseHeaders = new HashMap<>();
    responseHeaders.put("Content-Type", "application/json");
    APIGatewayProxyResponseEvent response = new APIGatewayProxyResponseEvent().withHeaders(responseHeaders);

    return response
        .withStatusCode(statusCode)
        .withBody(output);
  }
}
