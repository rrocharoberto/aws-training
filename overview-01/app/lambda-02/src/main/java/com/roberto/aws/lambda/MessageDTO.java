package com.roberto.aws.lambda;

public class MessageDTO {
    private String messageText;

    public MessageDTO(String message) {
        this.messageText = message;
    }
    
    public String getMessageText() {
        return messageText;
    }
}
