#!/bin/bash

# Set Python version to be installed
export python_version=3.8.7

# Install dependency package
sudo apt install libffi-dev

# Download Python tarball
wget -P/tmp https://www.python.org/ftp/python/${python_version}/Python-${python_version}.tgz

# Build and install Python
cd /tmp
tar xvf Python-${python_version}.tgz
cd Python-${python_version}
./configure --prefix=/usr/local/Python-${python_version} --with-openssl=/usr
make -j2
sudo make install

# Set environment for using new Python
echo "" >> ~/.bashrc
echo "# Set environment for Python" >> ~/.bashrc
echo "export LD_LIBRARY_PATH=/usr/local/Python-${python_version}/lib:\$LD_LIBRARY_PATH" >> ~/.bashrc
echo "export PATH=/usr/local/Python-${python_version}/bin:\$PATH" >> ~/.bashrc
source ~/.bashrc
