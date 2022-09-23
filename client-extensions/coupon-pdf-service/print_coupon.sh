#!/usr/bin/env bash

curl \
	--insecure \
	-H "Accept: application/pdf" \
	--output coupon.pdf \
	https://couponpdf.localdev.me/coupons/print