package com.suryansh;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.scheduling.annotation.EnableAsync;

@SpringBootApplication
@EnableAsync
@EnableCaching
public class IntelliBookSpringBootApplication {

	public static void main(String[] args) {
		SpringApplication.run(IntelliBookSpringBootApplication.class, args);
	}

}
