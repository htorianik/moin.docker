#!/usr/bin/python2
# -*- coding: iso-8859-1 -*-

import sys

sys.path.insert(0, "/opt/moin/etc/")

from MoinMoin.web.serving import make_application

application = make_application(shared=False)
