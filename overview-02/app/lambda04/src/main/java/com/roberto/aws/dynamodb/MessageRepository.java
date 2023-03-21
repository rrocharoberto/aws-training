package com.roberto.aws.dynamodb;

import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBMapper;
import com.roberto.aws.dynamodb.entity.MessageEntity;
import com.roberto.aws.dynamodb.util.RepositoryUtil;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class MessageRepository {

    private static final Logger logger = LoggerFactory.getLogger(MessageRepository.class);
    private String DYNAMODB_TABLE_NAME = "aws-training-message";
    
    public void saveMessage(MessageEntity message) {
        DynamoDBMapper mapper = RepositoryUtil.initDynamoDbClient(DYNAMODB_TABLE_NAME);

        logger.info("Saving message to DynamoDB");
        mapper.save(message);
        logger.info("Message saved successfully!!!");
    }
}
