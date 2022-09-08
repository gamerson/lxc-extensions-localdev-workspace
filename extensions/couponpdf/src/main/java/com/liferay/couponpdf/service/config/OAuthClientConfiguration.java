package com.liferay.couponpdf.service.config;

import java.util.Arrays;
import java.util.Collections;
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
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.reactive.function.client.WebClient;

@Configuration
public class OAuthClientConfiguration {

  @Value("${com.liferay.lxc.dxp.mainDomain}")
  private String _mainDomain;

  @Bean
  public ReactiveClientRegistrationRepository clientRegistrations(
      @Value("${couponpdf.oauth2.token.uri}") String tokenUri,
      @Value("${couponpdf.oauth2.headless.server.client.id}") String clientId,
      @Value("${couponpdf.oauth2.headless.server.client.secret}") String clientSecret,
      @Value("${couponpdf.oauth2.headless.server.scopes}") String scope) {

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
  public String mainDomain() {
	  return _mainDomain;
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

  @Bean
  public CorsConfigurationSource corsConfigurationSource() {
    CorsConfiguration configuration = new CorsConfiguration();
    //configuration.setAllowedOrigins(Collections.singletonList("https://" + mainDomain()));
    configuration.setAllowedOrigins(Collections.singletonList("*"));
    configuration.setAllowedMethods(
        Arrays.asList("DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"));
    configuration.setAllowedHeaders(Arrays.asList("Authorization", "Content-Type"));
    UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
    source.registerCorsConfiguration("/**", configuration);
    return source;
  }
}
