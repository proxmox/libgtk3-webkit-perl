RELEASE=3.0

PACKAGE=libgtk3-webkit-perl
PKGREL=2

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
	tar cf - ${DEB} | ssh repoman@repo.proxmox.com -- upload --product pve --dist stretch

.PHONY: dinstall
dinstall: ${DEB}
	dpkg -i ${DEB}

.phony: clean
clean: 
	rm -rf *~ debian/*~ ${OPKGNAME} ${PACKAGE}_*

