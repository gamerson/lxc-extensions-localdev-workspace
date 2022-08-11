package com.liferay.uscities.service;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class USCitiesServiceApp {

	public static void main(String[] args) {
		System.getenv().entrySet().stream().sorted(
			(a, b) -> a.getKey().compareTo(b.getKey())
		).forEach(
			e -> System.out.println(e.getKey() + "=" + e.getValue())
		);

		SpringApplication.run(USCitiesServiceApp.class, args);
	}

}
