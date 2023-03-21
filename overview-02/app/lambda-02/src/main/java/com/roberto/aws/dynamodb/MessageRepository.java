package com.roberto.aws.dynamodb;

import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBMapper;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBScanExpression;
import com.amazonaws.services.dynamodbv2.datamodeling.PaginatedScanList;
import com.roberto.aws.dynamodb.entity.MessageEntity;
import com.roberto.aws.dynamodb.util.RepositoryUtil;

import java.util.List;
import java.util.stream.Collectors;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class MessageRepository {

    private static final Logger logger = LoggerFactory.getLogger(MessageRepository.class);
    DynamoDBMapper ddbMapper;

    public MessageRepository(String messageDynamoTableName) {
        logger.info("Message DynamoDB table name: {}", messageDynamoTableName);
        ddbMapper = RepositoryUtil.initDynamoDbClient(messageDynamoTableName);
    }

    public void saveMessage(MessageEntity message) {

        logger.info("Saving message to DynamoDB");
        ddbMapper.save(message);
        logger.info("Message saved successfully!!!");
    }

    public List<MessageEntity> getAllMessages() {
        logger.info("Retrieving all messages from DynamoDB");
        PaginatedScanList<MessageEntity> messages = ddbMapper.scan(MessageEntity.class, new DynamoDBScanExpression());

        messages.loadAllResults();
        logger.info("Amount of messages retrieved: {}", messages.size());
        return messages.stream().collect(Collectors.toList());
    }
}
