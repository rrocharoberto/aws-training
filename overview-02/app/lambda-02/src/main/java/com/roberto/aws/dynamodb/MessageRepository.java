package com.roberto.aws.dynamodb;

import com.amazonaws.regions.Regions;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBMapper;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBMapperConfig;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBScanExpression;
import com.amazonaws.services.dynamodbv2.datamodeling.PaginatedScanList;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBMapperConfig.ConsistentReads;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBMapperConfig.TableNameOverride;
import com.roberto.aws.dynamodb.entity.MessageEntity;
import com.roberto.aws.dynamodb.util.RepositoryUtil;

import java.util.List;
import java.util.stream.Collectors;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class MessageRepository {

    private static final Logger logger = LoggerFactory.getLogger(MessageRepository.class);
    private String DYNAMODB_TABLE_NAME = "aws-training-message";
    DynamoDBMapper ddbMapper = RepositoryUtil.initDynamoDbClient(DYNAMODB_TABLE_NAME);

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
