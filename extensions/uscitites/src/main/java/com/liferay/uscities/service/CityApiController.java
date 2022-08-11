package com.liferay.uscities.service;


import java.io.IOException;
import java.util.Arrays;
import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.fasterxml.jackson.databind.ObjectMapper;

@RestController
@RequestMapping(value = "/city")
public class CityApiController {

	@Resource
	@Qualifier("mainDomain")
	String mainDomain;

	private static final Logger logger = LoggerFactory.getLogger(CityApiController.class);

	@ExceptionHandler(value = IOException.class)
    public ResponseEntity<String> handleResponseException(IOException ioException) {
		logger.error(ioException.getMessage());
        return new ResponseEntity<String>("Response exception: " + ioException.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
    }
	
	@GetMapping(value = "/search")
	public ResponseEntity<List<CityDetail>> search() throws IOException {
		ObjectMapper mapper = new ObjectMapper();

		List<CityDetail> cityDetails = Arrays.asList(mapper.readValue(CityApiController.class.getResourceAsStream("/USCities.json"), CityDetail[].class));
		
		return new ResponseEntity<List<CityDetail>>(cityDetails, HttpStatus.OK);
	}

//	private List<CityDetail> _mockDetails(String origin, String destination) {
//		CityDetail fd = new CityDetail();
//
//		fd.totalDuration = "PT14H30M";
//		Leg leg1 = new Leg();
//		leg1.airline = "AA";
//		leg1.departureCode = origin;
//		leg1.arrivalCode = "LHR";
//		leg1.duration = "8hr 44min";
//
//		Leg leg2 = new Leg();
//		leg2.airline = "BA";
//		leg2.departureCode = "LHR";
//		leg2.arrivalCode = destination;
//		leg2.duration = "3hr 10min";
//
//		fd.legs = new Leg[] {leg1, leg2};
//		
//		return Collections.singletonList(fd);
//	}

//	private static CityDetail _toDetail(CitySearch search) {
//		CityDetail detail = new CityDetail();
//		Itinerary itinerary = offer.getItineraries()[0];
//		detail.legs = Arrays.stream(
//			itinerary.getSegments()
//		).map(
//			FlightApiController::_toLeg
//		).collect(
//			Collectors.toList()
//		).toArray(
//			new Leg[0]
//		);
//		detail.totalDuration = itinerary.getDuration();
//		return detail;
//	}
//	
//	private static Leg _toLeg(SearchSegment segment) {
//		Leg leg = new Leg();
//		leg.airline = segment.getCarrierCode();
//		leg.departureCode = segment.getDeparture().getIataCode();
//		leg.arrivalCode = segment.getArrival().getIataCode();
//
//		Matcher matcher = _durationPattern.matcher(segment.getDuration().trim());
//
//		if (matcher.matches()) {
//			leg.duration = matcher.group(1) + (matcher.groupCount() == 5 ? matcher.group(3) : "");
//		}
//		else {
//			leg.duration = segment.getDuration();
//		}
//
//		return leg;
//	}

}