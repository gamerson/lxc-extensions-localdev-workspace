package com.liferay.couponpdf.service.config;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Arrays;
import java.util.Objects;

import org.springframework.core.env.PropertySource;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.EncodedResource;
import org.springframework.core.io.support.PropertySourceFactory;

public class SecretsPropertySourceFactory implements PropertySourceFactory {

	@Override
	public PropertySource<?> createPropertySource(String name, EncodedResource encodedResource) throws IOException {
		Resource resource = encodedResource.getResource();

		File file = resource.getFile();

		if (!file.isDirectory()) {
			throw new IOException("Expected directory.");
		}
		
		Files.list(file.toPath()).map(path -> {
			try {
				return path.toRealPath();
			} catch (IOException e1) {
				return null;
			}
		}).filter(
			Objects::nonNull
		);

		return null;
	}

}
