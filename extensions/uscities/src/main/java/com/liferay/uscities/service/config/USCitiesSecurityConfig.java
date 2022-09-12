package com.liferay.uscities.service.config;

import java.net.URI;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.convert.converter.Converter;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.RequestEntity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.oauth2.server.resource.introspection.SpringOpaqueTokenIntrospector;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

@Configuration
public class USCitiesSecurityConfig extends WebSecurityConfigurerAdapter {

	@Value("${com.liferay.lxc.dxp.mainDomain}")
	private String _mainDomain;

	@Bean
	public String mainDomain() {
		return _mainDomain;
	}

	@Value("${uscities.oauth2.user.agent.client.id}")
	private String clientId;

	@Value("${uscities.oauth2.introspection.uri}")
	private String introspectionUri;

	@Value("${com.liferay.lxc.dxp.domains}")
	private String _lxcDXPDomains;

	@Bean
	public List<String> allowedOrigins() {
		return Stream.of(
			_lxcDXPDomains.split("\\s*\n\\s*")
		).map(
			String::trim
		).map(
			"https://"::concat
		).collect(
			Collectors.toList()
		);
	}

	@Bean
	public CorsConfigurationSource corsConfigurationSource() {
		CorsConfiguration configuration = new CorsConfiguration();
		configuration.setAllowedOrigins(allowedOrigins());
		configuration.setAllowedMethods(
			Arrays.asList("DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"));
		configuration.setAllowedHeaders(
			Arrays.asList("Authorization", "Content-Type"));
		UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
		source.registerCorsConfiguration("/**", configuration);
		return source;
	}

	@Override
	protected void configure(HttpSecurity http) throws Exception {
		http.cors(
		).and(
		).authorizeRequests(
		).antMatchers(
			"/"
		).permitAll(
		).anyRequest(
		).authenticated(
		).and(
		).oauth2ResourceServer(
			oauth2 -> oauth2.opaqueToken().introspector(
				new CustomSpringOpaqueTokenIntrospector(
					introspectionUri, clientId)
			)
		);
	}

	private static class CustomSpringOpaqueTokenIntrospector extends SpringOpaqueTokenIntrospector {

		public CustomSpringOpaqueTokenIntrospector(String introspectionUri, String clientId) {
			super(introspectionUri, new RestTemplate());
			setRequestEntityConverter(customRequestEntityConverter(URI.create(introspectionUri), clientId));
		}

		private static Converter<String, RequestEntity<?>> customRequestEntityConverter(URI introspectionUri,
				String clientId) {
			return (token) -> {
				HttpHeaders headers = requestHeaders();
				MultiValueMap<String, String> body = requestBody(clientId, token);
				return new RequestEntity<>(body, headers, HttpMethod.POST, introspectionUri);
			};
		}

		private static HttpHeaders requestHeaders() {
			HttpHeaders headers = new HttpHeaders();
			headers.setAccept(Collections.singletonList(MediaType.APPLICATION_JSON));
			return headers;
		}

		private static MultiValueMap<String, String> requestBody(String clientId, String token) {
			MultiValueMap<String, String> body = new LinkedMultiValueMap<>();
			body.add("client_id", clientId);
			body.add("token", token);
			body.add("token_type_hint", "access_token");
			return body;
		}

	}

}