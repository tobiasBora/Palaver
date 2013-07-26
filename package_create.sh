#!/bin/bash -e
# Source : http://doc.ubuntu-fr.org/tutoriel/creer_un_paquet
# http://www.siteduzero.com/informatique/tutoriels/creer-un-paquet-deb/arborescence
# Scripts : http://askubuntu.com/questions/27715/create-a-deb-package-from-scripts-or-binaries

# Don't name a file with packag... in the beginning in root directory: it won't be add in package.

version="1.0"
package_name="palaver"
# Create a folder palaver-1.0/ for product the package in it.
rm -r packaging/ > /dev/null 2>&1 || true
mkdir packaging/
mkdir "packaging/${package_name}-${version}"

# We create the origin tarball
echo -n "Creating tarball... "
tar -czf /tmp/pack.tar.gz --transform 's,\(.*\),palaver/\1,' --transform "s/^packag.*//g" *
mv /tmp/pack.tar.gz "packaging/${package_name}_${version}.orig.tar.gz"
echo "Done"

echo "Creating arborescence"
cd "packaging/${package_name}-${version}/"
mkdir etc/
mkdir etc/palaver
mkdir usr/
mkdir usr/bin
cp -r ../../packaging_conf/* .
tar -xzf "../${package_name}_${version}.orig.tar.gz" -C etc/
ls debian/

echo "If you have any error (about predefs.h), please run
sudo apt-get install gcc-multilib
(for cross-compiling)"

# Don't words, I don't know why : (can compile source) (uses debian)
# debuild -S -sa --lintian-opts -i
# debuild -ai386 -us -uc 

# Works but doesn't compile without script (not very proper) (uses DEBIAN)
cd etc/palaver
echo "Compiling without any architecture option :"
make # This should be automatiquely executed, won't work if the computer doesn't have the good architecture
cd ../../..
dpkg -b "${package_name}-${version}"
mv "${package_name}-${version}.deb" "${package_name}-${version}_this_arch.deb"
echo "Compiling for 32 bits :"
sed -i 's/.*ARCH.*/ARCH=-m32/' "${package_name}-${version}/etc/${package_name}/Makefile"
dpkg -b "${package_name}-${version}"
mv "${package_name}-${version}.deb" "${package_name}-${version}_32_bits.deb"

echo "Compiling for 64 bits :"
sed -i 's/.*ARCH.*/ARCH=-m64/' "${package_name}-${version}/etc/${package_name}/Makefile"
dpkg -b "${package_name}-${version}"
mv "${package_name}-${version}.deb" "${package_name}-${version}_64_bits.deb"

