---
categories: null
comments: null
date: 2015-10-25T15:26:00Z
description: null
share: null
tags:
- openssl
- dev null
- s_client
- x509
- redirection
title: Wrapping OpenSSL for Simplified Usage
url: /blog/2015/10/25/wrapping-openssl-for-simplified-usage/
---

I routinely inspect live SSL certificates to validate domain coverage. While working directly with `openssl` is not *necessarily* painful, I wanted a tool that could be used to return a simple list of domains without the extra output and without the terminal hang. Below is an example of retrieving the SSL cert for google.com with `openssl s_client`:

```bash
$ openssl s_client -showcerts -connect google.com:443
CONNECTED(00000003)
depth=2 /C=US/O=GeoTrust Inc./CN=GeoTrust Global CA
verify error:num=20:unable to get local issuer certificate
verify return:0
---
Certificate chain
 0 s:/C=US/ST=California/L=Mountain View/O=Google Inc/CN=*.google.com
	 i:/C=US/O=Google Inc/CN=Google Internet Authority G2
-----BEGIN CERTIFICATE-----
{CERT CONTENTS}
-----END CERTIFICATE-----
 1 s:/C=US/O=Google Inc/CN=Google Internet Authority G2
	 i:/C=US/O=GeoTrust Inc./CN=GeoTrust Global CA
-----BEGIN CERTIFICATE-----
{CERT CONTENTS}
-----END CERTIFICATE-----
 2 s:/C=US/O=GeoTrust Inc./CN=GeoTrust Global CA
	 i:/C=US/O=Equifax/OU=Equifax Secure Certificate Authority
-----BEGIN CERTIFICATE-----
{CERT CONTENTS}
-----END CERTIFICATE-----
---
Server certificate
subject=/C=US/ST=California/L=Mountain View/O=Google Inc/CN=*.google.com
issuer=/C=US/O=Google Inc/CN=Google Internet Authority G2
---
No client certificate CA names sent
---
SSL handshake has read 4021 bytes and written 456 bytes
---
New, TLSv1/SSLv3, Cipher is AES128-SHA
Server public key is 2048 bit
Secure Renegotiation IS supported
Compression: NONE
Expansion: NONE
SSL-Session:
		Protocol  : TLSv1
		Cipher    : AES128-SHA
		Session-ID: C01EDE7DB78D6343DA2344F1FB9DDC962F39E92F8A1A98216E75F5C0F2285A2E
		Session-ID-ctx:
		Master-Key: F94716D18028CB0245582EECE632F956CF0B0FA208F6F4D66DD1BB78FF4B19AA6CA064E21811671D0082E33C1E6ECCB6
		Key-Arg   : None
		Start Time: 1445825624
		Timeout   : 300 (sec)
		Verify return code: 0 (ok)
---
# Terminal hangs here until CTRL-C
```

First, we can get rid of the terminal hang by updating the command as follows:

```
$ openssl s_client -showcerts -connect google.com:443 </dev/null
``` 

Next, we can reveal the certificate contents in human-readable form by piping to `x509`:

```bash
$ openssl s_client -showcerts -connect google.com:443 </dev/null \
  | openssl x509 -text
depth=2 /C=US/O=GeoTrust Inc./CN=GeoTrust Global CA
verify error:num=20:unable to get local issuer certificate
verify return:0
DONE
Certificate:
		Data:
				Version: 3 (0x2)
				Serial Number:
						0e:20:21:51:85:35:d8:61
				Signature Algorithm: sha256WithRSAEncryption
				Issuer: C=US, O=Google Inc, CN=Google Internet Authority G2
				Validity
						Not Before: Oct 28 18:49:32 2015 GMT
						Not After : Jan 26 00:00:00 2016 GMT
				Subject: C=US, ST=California, L=Mountain View, O=Google Inc, CN=*.google.com
				Subject Public Key Info:
						Public Key Algorithm: rsaEncryption
						RSA Public Key: (2048 bit)
								Modulus (2048 bit):
										00:ca:41:bd:af:ea:f6:af:44:d8:fe:57:b1:53:52:
										a8:e4:ca:63:89:bb:72:ce:2d:45:ed:3d:7c:e9:9a:
										fe:1b:81:0b:4a:4c:4b:5d:68:a7:1b:1e:76:38:b1:
										dc:d2:ba:d6:e7:01:5f:39:34:87:5b:59:7e:88:4c:
										3b:32:79:57:ab:e0:82:0d:c8:da:c4:6f:27:98:1b:
										b2:25:e1:7b:f1:44:ca:94:2d:51:c9:dd:ac:2b:b8:
										6e:c4:7d:dd:bd:3f:b5:51:1c:a7:25:e5:bd:9d:df:
										ef:8e:fa:d4:ce:76:7c:07:74:50:49:a3:43:7b:8b:
										fc:f8:6a:4c:1d:00:e7:32:5f:aa:f1:57:5c:6f:21:
										d0:8e:0d:42:02:f0:dd:08:f6:6b:75:c3:73:c6:13:
										da:f2:0d:97:18:10:0f:c3:bb:63:74:9a:42:79:0a:
										0e:ee:a9:4a:73:6b:dc:9e:a8:08:39:d0:99:48:4d:
										89:d4:b0:31:1c:eb:18:c8:17:22:fd:6e:85:3f:e6:
										b1:64:fc:ca:f7:cb:d7:84:77:e6:02:88:85:6b:ea:
										5b:af:eb:be:fc:e2:07:3c:f1:71:b1:b1:f0:0d:80:
										81:a0:1b:c6:50:28:32:3c:8e:78:55:76:f8:75:30:
										36:64:a2:bf:1c:46:06:ad:46:75:3e:59:b0:cd:bc:
										45:93
								Exponent: 65537 (0x10001)
				X509v3 extensions:
						X509v3 Extended Key Usage:
								TLS Web Server Authentication, TLS Web Client Authentication
						X509v3 Subject Alternative Name:
								DNS:*.google.com, DNS:*.android.com, DNS:*.appengine.google.com, DNS:*.cloud.google.com, DNS:*.google-analytics.com, DNS:*.google.ca, DNS:*.google.cl, DNS:*.google.co.in, DNS:*.google.co.jp, DNS:*.google.co.uk, DNS:*.google.com.ar, DNS:*.google.com.au, DNS:*.google.com.br, DNS:*.google.com.co, DNS:*.google.com.mx, DNS:*.google.com.tr, DNS:*.google.com.vn, DNS:*.google.de, DNS:*.google.es, DNS:*.google.fr, DNS:*.google.hu, DNS:*.google.it, DNS:*.google.nl, DNS:*.google.pl, DNS:*.google.pt, DNS:*.googleadapis.com, DNS:*.googleapis.cn, DNS:*.googlecommerce.com, DNS:*.googlevideo.com, DNS:*.gstatic.cn, DNS:*.gstatic.com, DNS:*.gvt1.com, DNS:*.gvt2.com, DNS:*.metric.gstatic.com, DNS:*.urchin.com, DNS:*.url.google.com, DNS:*.youtube-nocookie.com, DNS:*.youtube.com, DNS:*.youtubeeducation.com, DNS:*.ytimg.com, DNS:android.clients.google.com, DNS:android.com, DNS:g.co, DNS:goo.gl, DNS:google-analytics.com, DNS:google.com, DNS:googlecommerce.com, DNS:urchin.com, DNS:youtu.be, DNS:youtube.com, DNS:youtubeeducation.com
						Authority Information Access:
								CA Issuers - URI:http://pki.google.com/GIAG2.crt
								OCSP - URI:http://clients1.google.com/ocsp

						X509v3 Subject Key Identifier:
								24:9E:07:37:EA:BF:A9:3B:D8:47:0C:E1:1C:97:62:D5:00:91:24:9D
						X509v3 Basic Constraints: critical
								CA:FALSE
						X509v3 Authority Key Identifier:
								keyid:4A:DD:06:16:1B:BC:F6:68:B5:76:F5:81:B6:BB:62:1A:BA:5A:81:2F

						X509v3 Certificate Policies:
								Policy: 1.3.6.1.4.1.11129.2.5.1
								Policy: 2.23.140.1.2.2

						X509v3 CRL Distribution Points:
								URI:http://pki.google.com/GIAG2.crl

		Signature Algorithm: sha256WithRSAEncryption
				08:0d:58:57:dd:8a:b5:4e:36:d6:89:2a:b5:0f:88:a5:01:d0:
				21:80:fc:f5:11:8d:d4:08:5a:75:22:ac:5b:23:09:0d:bb:50:
				1b:73:90:55:6e:b6:35:d0:4d:d7:43:9d:e4:21:f3:66:8b:9b:
				e0:57:7d:40:48:e5:70:f5:20:25:bf:9c:9a:f1:ba:89:bf:33:
				2a:61:7e:77:23:95:f9:fa:90:1c:e3:54:f2:8c:aa:f1:5b:df:
				62:81:c1:79:3f:b5:c0:6d:75:ca:59:3b:3f:a3:9d:13:e6:3c:
				e0:08:cd:2f:b3:9f:af:9c:20:ee:1b:91:6c:f2:bd:c0:db:76:
				7b:16:3d:1c:31:cd:0e:c4:03:93:89:56:ca:8a:4d:80:18:85:
				86:7b:37:74:cd:e7:c5:72:b5:07:32:9e:35:5c:01:62:5c:7e:
				c3:e7:32:5e:9e:61:35:0d:a7:32:40:70:26:75:71:d0:fc:90:
				62:eb:ac:0c:1a:61:a2:18:39:1c:8c:06:c5:0a:4f:27:be:e0:
				2c:d3:83:cd:c4:7c:67:f9:38:0a:ca:0a:49:7d:5e:59:36:f1:
				ed:90:3b:bb:ea:74:87:95:31:16:97:bb:34:60:a9:ac:74:48:
				8e:ed:7b:4a:09:10:18:8d:58:8a:ee:34:2f:7c:f2:55:97:3f:
				5a:01:9c:07
-----BEGIN CERTIFICATE-----
{CERT CONTENTS}
-----END CERTIFICATE-----
```    

Now that we have the cert contents, the next thing we can do is filter out the list of domains:

```bash
$ openssl s_client -showcerts -connect google.com:443 </dev/null \
  | openssl x509 -text \
  | grep DNS \
  | tr ',' '\n' \
  | cut -d':' -f2
depth=2 /C=US/O=GeoTrust Inc./CN=GeoTrust Global CA
verify error:num=20:unable to get local issuer certificate
verify return:0
DONE
*.google.com
{LOTS MORE DOMAINS}
youtubeeducation.com
```

At this point (or maybe much earlier), you might notice that there is some extra data printed to `STDERR`:

```bash
depth=2 /C=US/O=GeoTrust Inc./CN=GeoTrust Global CA
verify error:num=20:unable to get local issuer certificate
verify return:0
DONE
```

The above is indicating that the cert is not properly validated against a known root certificate. Let's get that validated!

First let's get the CA cert bundle from curl.haxx.se:

```bash
$ curl -O http://curl.haxx.se/ca/cacert.pem
```

Now we can reference the CA with `s_client`:

```bash
$ openssl s_client -showcerts \
	-CAfile /path/to/cacert.pem \
	-connect google.com:443 </dev/null \
  | openssl x509 -text \
  | grep DNS \
  | tr ',' '\n' \
  | cut -d':' -f2
depth=3 /C=US/O=Equifax/OU=Equifax Secure Certificate Authority
verify return:1
depth=2 /C=US/O=GeoTrust Inc./CN=GeoTrust Global CA
verify return:1
depth=1 /C=US/O=Google Inc/CN=Google Internet Authority G2
verify return:1
depth=0 /C=US/ST=California/L=Mountain View/O=Google Inc/CN=*.google.com
verify return:1
DONE
{LIST OF DOMAINS}
```

Now we're properly validated, but the validation data is still printing to `STDERR`. Of course we can keep this as-is for proper assurance, but for now let's get rid of the clutter by sending `STDERR` to `STDOUT`.

```bash
$ openssl s_client -showcerts \
	-CAfile /path/to/cacert.pem -connect google.com:443 </dev/null 2>&1 \
  | openssl x509 -text \
  | grep DNS \
  | tr ',' '\n' \
  | cut -d':' -f2
{JUST DOMAINS!}
```

Lastly, we can add an enhancement to alert for failed validation, but otherwise to provide the list of domains:

```bash
LIVE_CERT=$(openssl s_client -showcerts \
  -CAfile /path/to/cacert.pem -connect google.com:443 </dev/null 2>&1)
VALIDATION=$(echo "$LIVE_CERT" | grep -c -E '^verify error')
[[ $VALIDATION > 0 ]] && >&2 echo 'failed cert validation' \
  || echo "$LIVE_CERT" \
    | openssl x509 -text \
    | grep DNS \
    | tr ',' '\n' \
    | cut -d':' -f2
```

Wrap that in a bash function or executable with an easy-to-remember name, and you've got a very convenient tool for listing the domains covered by an SSL cert.
