#!/bin/bash

#Update & upgrade system
aptitude update
#aptitude -y safe-upgrade

#Install required packages from repos
aptitude -y install python2.7 python2.7-dev python-pip build-essential autoconf libtool \
git subversion libboost-all-dev libboost-python-dev python-setuptools libxml2-dev libxslt-dev \
graphviz mongodb flex bison

#Download Thug
cd /opt
git clone https://github.com/buffer/thug.git

#Patch and install Google V8 (PyV8 will also install V8)
cd /tmp
svn checkout http://v8.googlecode.com/svn/trunk/ v8
svn checkout http://pyv8.googlecode.com/svn/trunk/ pyv8
cp /opt/thug/patches/PyV8-patch1.diff .
patch -p0 < PyV8-patch1.diff
export V8_HOME=/tmp/v8
cd pyv8
python setup.py build
python setup.py install

#Install packages via pip
pip install beautifulsoup4
pip install html5lib
pip install jsbeautifier

#Install Libemu
cd /tmp
git clone git://git.carnivore.it/libemu.git
cd libemu
autoreconf -v -i
./configure --prefix=/opt/libemu
make install

#Install Pylibemu
cd /tmp
git clone git://github.com/buffer/pylibemu.git
cd pylibemu
python setup.py build
python setup.py install

#Install more packages via pip
pip install pefile
pip install lxml
pip install chardet
pip install httplib2
pip install requests
pip install cssutils
pip install zope.interface
pip install pyparsing
pip install pydot2
pip install python-magic
pip install rarfile
pip install pymongo
pip install requesocks

#Install Yara
cd /opt
git clone https://github.com/plusvic/yara.git
cd yara/
bash build.sh
make install

#Install Yara-Python
cd /opt/yara/yara-python
python setup.py build
python setup.py install

#Fix Libemu shared libs
touch /etc/ld.so.conf.d/libemu.conf
echo "/opt/libemu/lib/" > /etc/ld.so.conf.d/libemu.conf
ldconfig

#Test Thug
python /opt/thug/src/thug.py -h
