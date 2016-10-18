#!/bin/bash

ebuild_unpack() {
  if [ -d "${WORKDIR}" ] 
  then
    rm -f "${WORKDIR}"
  fi

  mkdir "${WORKDIR}"

  cd "${WORKDIR}"
  if [ ! -e "${DISTDIR}/${A}" ] 
  then
    echo "Download source ${A} before!"
    exit 1
  fi

  tar zxf "${DISTDIR}/${A}"
  echo "Unpacked ${DISTDIR}/${A}."
}

user_compile() {
  pwd
  if [ -e configure ] 
  then
    ./configure  --prefix=/usr
  fi

  make ${MAKEOPTS} MAKE="make ${MAKEOPTS}"
}

ebuild_compile() {
  if [ ! -d ${SRCDIR} ] 
  then
    echo "Please unpack ${A} first to ${WORKDIR}"
    exit 1
  fi

  cd ${SRCDIR}
  user_compile
}

CONF="/etc/ebuild.conf"

if [ $# -ne 2 ] 
  then
  echo "Script should be started with 2 arguments: ebuild file and operation name"
  exit 1
fi

source ${CONF}

if [ -z "${DISTDIR}" ] 
then
  DISTDIR="/usr/src/distfiles"
fi

export DISTDIR

ORIGDIR=${PWD}
WORKDIR="${ORIGDIR}/work"

if [ -e "$1" ] 
then
  source "$1"
else
  echo "$1 source file not exists!"
  exit 1
fi

SRCDIR="${WORKDIR}/${P}"
export ORIGDIR
export WORKDIR
export SRCDIR

case $2 in
  compile)
    ebuild_compile
    ;;
  unpack)
    ebuild_unpack
    ;;
  all)
    ebuild_unpack
    ebuild_compile
    ;;
  *)
    echo "Wrong second argument. Should be build|compile|all"
    ;;
esac

exit 0
