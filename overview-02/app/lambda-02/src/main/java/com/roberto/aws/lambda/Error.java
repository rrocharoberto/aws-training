package com.roberto.aws.lambda;

public class Error {
    int statusCode;
    String result;

    public Error(int statusCode, String result) {
        this.statusCode = statusCode;
        this.result = result;
    }
}
