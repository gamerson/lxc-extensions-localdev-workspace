package com.liferay.uscities.service;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.springframework.security.oauth2.core.OAuth2AccessToken;
import org.springframework.security.oauth2.server.resource.authentication.BearerTokenAuthentication;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

@RestController
@RequestMapping(value = "/random")
public class RandomRestController {

	@Resource
	@Qualifier("mainDomain")
	String mainDomain;

	private static final Logger logger = LoggerFactory.getLogger(RandomRestController.class);

	@PutMapping(value = "/user/{id}")
	public void updateGivenName(@PathVariable Long id, HttpEntity<String> requestEntity, BearerTokenAuthentication authentication) {
		OAuth2AccessToken authToken = authentication.getToken();
		String accessToken = authToken.getTokenValue();

		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_JSON);
		headers.set("Authorization", "Bearer " + accessToken);

		String newGivenName = requestEntity.getBody();

		HttpEntity<String> entity = new HttpEntity<String>(
			"{\"givenName\":\"" + newGivenName + "\"}", headers);
		RestTemplate restTemplate = new RestTemplate();
		restTemplate.setRequestFactory(new HttpComponentsClientHttpRequestFactory());
		String result = restTemplate.patchForObject(
			"https://" + mainDomain + "/o/headless-admin-user/v1.0/user-accounts/" + id,
			entity, String.class);
		logger.info("User patched " + result);
	}

}