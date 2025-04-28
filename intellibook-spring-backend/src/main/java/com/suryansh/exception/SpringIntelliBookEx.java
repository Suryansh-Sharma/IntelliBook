package com.suryansh.exception;

import lombok.*;
import org.springframework.http.HttpStatus;

import java.time.LocalDateTime;

@Getter
public class SpringIntelliBookEx extends RuntimeException {
    private final String errorCode;
    private final HttpStatus status;
    private final LocalDateTime timestamp;

    public SpringIntelliBookEx(String message, String errorCode, HttpStatus status) {
        super(message);
        this.errorCode = errorCode;
        this.status = status;
        this.timestamp = LocalDateTime.now();
    }

}
