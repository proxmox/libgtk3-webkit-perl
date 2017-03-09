RELEASE=3.0

PACKAGE=libgtk3-webkit-perl
PKGREL=1

ARCH=all

OPKGNAME=Gtk3-WebKit-0.03
DEB = ${PACKAGE}_0.03-${PKGREL}_${ARCH}.deb

${DEB}: ${OPKGNAME}.tar.gz
	-rm -rf ${OPKGNAME}
	tar xzf ${OPKGNAME}.tar.gz
	cp -a debian ${OPKGNAME}
	cd ${OPKGNAME}; dpkg-buildpackage -b -us -uc
	-rm -rf ${OPKGNAME}
	lintian ${DEB}


.phony: upload
upload: ${DEB}
	umount /pve/${RELEASE}; mount /pve/${RELEASE} -o rw 
	mkdir -p /pve/${RELEASE}/extra
	rm -rf /pve/${RELEASE}/extra/${PACKAGE}_*.deb
	rm -f /pve/${RELEASE}/extra/Packages*
	cp ${DEB} /pve/${RELEASE}/extra
	cd /pve/${RELEASE}/extra; dpkg-scanpackages . /dev/null | gzip -9c > Packages.gz
	umount /pve/${RELEASE}; mount /pve/${RELEASE} -o ro

.PHONY: dinstall
dinstall: ${DEB}
	dpkg -i ${DEB}

.phony: clean
clean: 
	rm -rf *~ debian/*~ ${OPKGNAME} ${PACKAGE}_*

