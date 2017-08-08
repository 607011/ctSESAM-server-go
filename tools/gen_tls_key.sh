#!/bin/bash

CERTDIR=./cert
PRIVDIR=$CERTDIR/private
NAME=server
SERIAL=1000

if [ ! -d "$CERTDIR" ]; then
  mkdir -p $CERTDIR
else
  rm -f $CERTDIR/$NAME.csr
  rm -f $CERTDIR/$NAME.crt
  rm -f $CERTDIR/index.txt
  rm -f $CERTDIR/index.txt.attr
  rm -f $CERTDIR/index.txt.old
  rm -f $CERTDIR/$SERIAL.pem
  rm -f $CERTDIR/serial
  rm -f $CERTDIR/serial.old  
fi

if [ ! -d "$PRIVDIR" ]; then
  mkdir -p $PRIVDIR
else
  rm -f $PRIVDIR/$NAME.key
fi


touch $CERTDIR/index.txt
echo $SERIAL > $CERTDIR/serial

openssl genrsa \
  -out $PRIVDIR/$NAME.key \
  4096

openssl req \
  -new \
  -batch \
  -out $CERTDIR/$NAME.csr \
  -key $PRIVDIR/$NAME.key \
  -nodes \
  -sha256 \
  -days 365 \
  -config init/openssl.cnf

openssl req -text -noout -verify -in $CERTDIR/$NAME.csr

openssl x509 \
  -req \
  -in $CERTDIR/$NAME.csr \
  -signkey $PRIVDIR/$NAME.key \
  -out $CERTDIR/$NAME.crt

openssl ca \
  -batch \
  -in $CERTDIR/$NAME.csr \
  -out $CERTDIR/$NAME.crt \
  -config init/openssl.cnf \
  -extensions v3_req

openssl x509 -text -noout -in $CERTDIR/$NAME.crt
