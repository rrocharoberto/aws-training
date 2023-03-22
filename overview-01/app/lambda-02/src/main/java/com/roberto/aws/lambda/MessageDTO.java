package com.roberto.aws.lambda;

public class MessageDTO {
    private String text;

    public MessageDTO(String text) {
        this.text = text;
    }
    
    public String getText() {
        return text;
    }
}
