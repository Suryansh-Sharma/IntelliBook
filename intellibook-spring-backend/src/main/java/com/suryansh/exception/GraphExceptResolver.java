package com.suryansh.exception;

import graphql.GraphQLError;
import graphql.GraphqlErrorBuilder;
import graphql.schema.DataFetchingEnvironment;
import jakarta.validation.ConstraintViolation;
import jakarta.validation.ConstraintViolationException;
import org.springframework.graphql.execution.DataFetcherExceptionResolverAdapter;
import org.springframework.graphql.execution.ErrorType;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;
import java.util.Set;


@Component
public class GraphExceptResolver extends DataFetcherExceptionResolverAdapter {

    @Override
    protected GraphQLError resolveToSingleError(Throwable ex, DataFetchingEnvironment env) {
        if (ex instanceof SpringIntelliBookEx exception) {
            return GraphqlErrorBuilder.newError()
                    .errorType(ErrorType.BAD_REQUEST)  // Use a standard error type
                    .message(exception.getMessage())
                    .extensions(Map.of(
                            "errorCode", exception.getErrorCode(),
                            "status", exception.getStatus().value(),
                            "timestamp", exception.getTimestamp().toString()
                    ))
                    .path(env.getExecutionStepInfo().getPath())
                    .build();
        } else if (ex instanceof ConstraintViolationException constraintViolationException) {
            Set<ConstraintViolation<?>> constraintViolations = constraintViolationException.getConstraintViolations();

            // Collect all validation messages into a list
            List<String> violationMessages = constraintViolations.stream()
                    .map(ConstraintViolation::getMessage)
                    .toList();

            return GraphqlErrorBuilder.newError()
                    .errorType(ErrorType.BAD_REQUEST)
                    .message("Validation Error: " + String.join(", ", violationMessages))
                    .path(env.getExecutionStepInfo().getPath())
                    .build();
        }

        return null;
    }
}
