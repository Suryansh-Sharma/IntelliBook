package com.suryansh.dto.analytics;

import java.math.BigDecimal;

public record TwoVariableDataTrend(
    String topic,
    BigDecimal amount
) {
}
