package com.roberto.aws.service;

import java.util.List;
import java.util.stream.Collectors;

import com.roberto.aws.dynamodb.MessageRepository;
import com.roberto.aws.dynamodb.entity.MessageEntity;
import com.roberto.aws.lambda.MessageDTO;

public class MessageService {

    private String dynamoDBTableName = System.getenv("MESSAGE_DYNAMODB_TABLE_NAME");
    private MessageRepository repo = new MessageRepository(dynamoDBTableName);

    public String saveMessage(MessageDTO msg) {
        MessageEntity message = new MessageEntity(Long.toString(System.currentTimeMillis()), msg.getMessageText());
        repo.saveMessage(message);
        return "Save success.";
    }

    public List<MessageDTO> listMessages() {
        List<MessageEntity> messages = repo.getAllMessages();
        return messages.stream().map(m -> new MessageDTO(m.getMessageText())).collect(Collectors.toList());
    }
}
