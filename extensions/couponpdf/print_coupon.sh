#!/usr/bin/env bash

curl \
	--insecure \
	-X POST \
	-H "Accept: application/pdf" \
	-H "Content-Type: application/x-www-form-urlencoded;charset=UTF-8" \
	-d 'couponId=' \
	--output coupon.pdf \
	https://couponpdf.localdev.me/coupons/print