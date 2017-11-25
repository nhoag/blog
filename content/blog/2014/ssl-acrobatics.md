---
comments: true
date: 2014-01-28T22:26:42Z
tags:
- ssl
- openssl
- x509
- format
- validate
title: SSL Acrobatics
url: /blog/2014/01/28/ssl-acrobatics/
---

I flip a lot of websites around between servers, and often haven to migrate SSL certificates as part of the process. The below openssl commands represent most of what I encounter in terms of validations and encoding conversions.

## Primer

First, a couple of basics on certificate components. The four SSL components to know are the Certificate Signing Request (CSR), the key, the certificate, and the Certificate Authority (CA) intermediate certificates. When starting fresh, you'll first generate a CSR and a key. The CSR can then be taken to a Certificate Provider to generate the certificate, while the key should be protected at all costs.

## Finding SSL Components

Primer over, let's get down to the business of moving existing certificates. **Depending on permissions and ownership, you may need root access for some of the following.**

To find a certificate on an unfamiliar web server, you'll want to reference the VirtualHost (vhost) file. If you don't know the location of the vhost, you'll want to run something like the following command to get a list of vhosts on the server:

```
/usr/local/apache2/bin/httpd -S
```

Once you've pinpointed the vhost location, scan the file for the SSLCertificateFile and SSLCertificateKeyFile references:

```
<VirtualHost ipaddress:443>
        SSLEngine on
	# snip
        SSLCertificateFile      /path/to/ssl.crt
        SSLCertificateKeyFile   /path/to/ssl.key
	# snip
</VirtualHost>
```

We can now proceed with the referenced ssl.crt and ssl.key files from the vhost.

## Certificate Encoding

In validating certificate components, you may encounter an `unable to load certificate` error. This means the certificate component is not encoded in the expected format. Following are a few commands for testing and transforming the encoding of certificate components.

Test if the key is PEM or DER:

```
# PEM
openssl rsa -inform PEM -in ssl.key
# DER
openssl rsa -in ssl.key -inform DER -text -noout
```

Test if the certificate is PEM or DER:

```
# PEM
openssl x509 -inform PEM -in ssl.crt # PEM
# DER
openssl x509 -in ssl.crt -inform DER -text -noout # DER
```

Convert the key to a new encoding:

```
# PEM
openssl rsa -in key.der -inform DER -out key.pem -outform PEM
# DER
openssl rsa -in key.pem -inform PEM -out key.der -outform DER
```

Convert the certificate to a new encoding:

```
# PEM
openssl x509 -in ssl.der -inform DER -out ssl.pem -outform PEM
# DER
openssl x509 -in ssl.pem -inform PEM -out ssl.der -outform DER
```

## Validate SSL Components

Do the certificate and key match?

```
# LONG FORM
(openssl x509 -in ssl.crt -noout -pubkey; \
openssl rsa -in ssl.key -pubout)

# SHORT FORM
(openssl x509 -noout -modulus -in ssl.crt | openssl md5; \
openssl rsa -noout -modulus -in ssl.key | openssl md5)
```

Check the dates that the certificate is valid:

```
openssl x509 -noout -in ssl.crt -dates
```

View the entire contents of the cert:

```
openssl x509 -in ssl.crt -noout -text
```

You may not have the CA intermediate certificates. These can be acquired from vendors by certificate type. As an example, you might see `CN=DigiCert High Assurance CA-3` in the certificate contents. This would lead you to the [Digicert Root and Intermediate Certificate](https://www.digicert.com/digicert-root-certificates.htm) webpage, where you can reference the table for the appropriate CA intermediate certificate download.

Verifying the certificate chain:

```
openssl verify -CAfile chain.crt ssl.crt
```

* **Note:** You may need to also convert the encoding of the intermediate cert.

## Conclusion

Once everything is validated and converted to the expected encoding, you can proceed with installation of the SSL Certificate on firm footing.
