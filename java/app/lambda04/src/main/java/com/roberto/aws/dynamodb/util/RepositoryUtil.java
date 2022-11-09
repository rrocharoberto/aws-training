package com.roberto.aws.dynamodb.util;

import com.amazonaws.regions.Regions;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBMapper;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBMapperConfig;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBMapperConfig.ConsistentReads;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBMapperConfig.TableNameOverride;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class RepositoryUtil {

    private static final Logger logger = LoggerFactory.getLogger(RepositoryUtil.class);

    private static Regions REGION = Regions.US_EAST_1;

    private static AmazonDynamoDB dynamoDBBuilder;
    private static DynamoDBMapper mapper;
    
    public static DynamoDBMapper initDynamoDbClient(String tableName) {
        logger.info("Initializing DynamoDB client");

        dynamoDBBuilder = AmazonDynamoDBClientBuilder.standard().withRegion(REGION).build();

        mapper = new DynamoDBMapper(dynamoDBBuilder, 
            DynamoDBMapperConfig.builder()
                .withTableNameOverride(TableNameOverride.withTableNameReplacement(tableName))
                .withConsistentReads(ConsistentReads.CONSISTENT)
                .build());
        return mapper;
    }
}
