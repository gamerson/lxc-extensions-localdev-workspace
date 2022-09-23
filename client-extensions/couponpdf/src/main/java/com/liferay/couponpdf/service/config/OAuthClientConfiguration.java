package com.liferay.couponpdf.service.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.oauth2.client.AuthorizedClientServiceReactiveOAuth2AuthorizedClientManager;
import org.springframework.security.oauth2.client.InMemoryReactiveOAuth2AuthorizedClientService;
import org.springframework.security.oauth2.client.registration.ClientRegistration;
import org.springframework.security.oauth2.client.registration.InMemoryReactiveClientRegistrationRepository;
import org.springframework.security.oauth2.client.registration.ReactiveClientRegistrationRepository;
import org.springframework.security.oauth2.client.web.reactive.function.client.ServerOAuth2AuthorizedClientExchangeFilterFunction;
import org.springframework.security.oauth2.core.AuthorizationGrantType;
import org.springframework.security.oauth2.core.ClientAuthenticationMethod;
import org.springframework.web.reactive.function.client.WebClient;

@Configuration
public class OAuthClientConfiguration {

  @Bean
  public ReactiveClientRegistrationRepository clientRegistrations(
      @Value("${coupon.headless.server.application.oauth2.token.uri}") String tokenUri,
      @Value("${coupon.headless.server.application.oauth2.headless.server.client.id}") String clientId,
      @Value("${coupon.headless.server.application.oauth2.headless.server.client.secret}") String clientSecret,
      @Value("${coupon.headless.server.application.oauth2.headless.server.scopes}") String scope) {

    ClientRegistration registration =
        ClientRegistration.withRegistrationId("dxp")
            .tokenUri(tokenUri)
            .clientId(clientId)
            .clientSecret(clientSecret)
            .scope(scope)
            .authorizationGrantType(AuthorizationGrantType.CLIENT_CREDENTIALS)
            .clientAuthenticationMethod(ClientAuthenticationMethod.CLIENT_SECRET_POST)
            .build();

    return new InMemoryReactiveClientRegistrationRepository(registration);
  }

  @Bean
  public WebClient webClient(ReactiveClientRegistrationRepository clientRegistrations) {
    ServerOAuth2AuthorizedClientExchangeFilterFunction oauth =
        new ServerOAuth2AuthorizedClientExchangeFilterFunction(
            new AuthorizedClientServiceReactiveOAuth2AuthorizedClientManager(
                clientRegistrations,
                new InMemoryReactiveOAuth2AuthorizedClientService(clientRegistrations)));

    oauth.setDefaultClientRegistrationId("dxp");

    return WebClient.builder().filter(oauth).build();
  }
}
