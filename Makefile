#########################################################################
#
# Copyright 2013 by Sean Conner.  All Rights Reserved.
#
# This library is free software; you can redistribute it and/or modify it
# under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation; either version 3 of the License, or (at your
# option) any later version.
#
# This library is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
# or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public
# License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this library; if not, see <http://www.gnu.org/licenses/>.
#
# Comments, questions and criticisms can be sent to: sean@conman.org
#
########################################################################

.PHONY: all clean install install-lua remove remove-lua

UNAME := $(shell uname)

ifeq ($(UNAME),Linux)
  CC      = gcc -std=c99
  CFLAGS  = -g -Wall -Wextra -pedantic
  LDFLAGS = -shared
  LDLIBS  = -lrt -lcrypto
  SHARED  = -fPIC
  AR      = ar rcu
  RANLIB  = ranlib
endif

ifeq ($(UNAME),SunOS)
  CC     = cc -xc99
  CFLAGS = -g
  LDLIBS = -lrt -lsocket -lnsl -lcrypto
  AR     = ar rcu
  RANLIB = ranlib
endif

# =============================================

INCLUDE = /usr/local/include
LIB     = /usr/local/lib
LUALIB  = /usr/local/lib/lua/5.1

# ============================================

obj/%.o : src/%.c
	$(CC) $(CFLAGS) -c -o $@ $<

so/%.o : src/%.c
	$(CC) $(CFLAGS) $(SHARED) -c -o $@ $<

all : lib obj lib/libspcuuid.a

lua : so lib lib/lua-uuid.so

lib :
	mkdir lib

obj :
	mkdir obj

so : 
	mkdir so

# ==========================================

lib/libspcuuid.a : obj/uuid_ns_dns.o	\
		obj/uuid_ns_null.o	\
		obj/uuid_ns_oid.o	\
		obj/uuid_ns_url.o	\
		obj/uuid_ns_x500.o	\
		obj/uuidlib_cmp.o	\
		obj/uuidlib_parse.o	\
		obj/uuidlib_toa.o	\
		obj/uuidlib_v1.o	\
		obj/uuidlib_v2.o	\
		obj/uuidlib_v3.o	\
		obj/uuidlib_v4.o	\
		obj/uuidlib_v5.o
	$(AR) $@ $?
	$(RANLIB) $@

lib/lua-uuid.so : so/luauuid.o		\
		so/uuid_ns_dns.o	\
		so/uuid_ns_null.o	\
		so/uuid_ns_oid.o	\
		so/uuid_ns_url.o	\
		so/uuid_ns_x500.o	\
		so/uuidlib_cmp.o	\
		so/uuidlib_parse.o	\
		so/uuidlib_toa.o	\
		so/uuidlib_v1.o		\
		so/uuidlib_v2.o		\
		so/uuidlib_v3.o		\
		so/uuidlib_v4.o		\
		so/uuidlib_v5.o
	$(CC) $(LDFLAGS) -o $@ $^ $(LDLIBS)

# ===========================================================

obj/uuid_ns_dns.o   : src/uuid_ns_dns.c   src/uuid.h
obj/uuid_ns_null.o  : src/uuid_ns_null.c  src/uuid.h
obj/uuid_ns_oid.o   : src/uuid_ns_oid.c   src/uuid.h
obj/uuid_ns_url.o   : src/uuid_ns_url.c   src/uuid.h
obj/uuid_ns_x500.o  : src/uuid_ns_x500.c  src/uuid.h
obj/uuidlib_cmp.o   : src/uuidlib_cmp.c   src/uuid.h
obj/uuidlib_parse.o : src/uuidlib_parse.c src/uuid.h
obj/uuidlib_toa.o   : src/uuidlib_toa.c   src/uuid.h
obj/uuidlib_v1.o    : src/uuidlib_v1.c    src/uuid.h
obj/uuidlib_v2.o    : src/uuidlib_v2.c    src/uuid.h
obj/uuidlib_v3.o    : src/uuidlib_v3.c    src/uuid.h
obj/uuidlib_v4.o    : src/uuidlib_v4.c    src/uuid.h
obj/uuidlib_v5.o    : src/uuidlib_v5.c    src/uuid.h

# ===================================================

so/luauuid.o       : src/luauuid.c       src/uuid.h
so/uuid_ns_dns.o   : src/uuid_ns_dns.c   src/uuid.h
so/uuid_ns_null.o  : src/uuid_ns_null.c  src/uuid.h
so/uuid_ns_oid.o   : src/uuid_ns_oid.c   src/uuid.h
so/uuid_ns_url.o   : src/uuid_ns_url.c   src/uuid.h
so/uuid_ns_x500.o  : src/uuid_ns_x500.c  src/uuid.h
so/uuidlib_cmp.o   : src/uuidlib_cmp.c   src/uuid.h
so/uuidlib_parse.o : src/uuidlib_parse.c src/uuid.h
so/uuidlib_toa.o   : src/uuidlib_toa.c   src/uuid.h
so/uuidlib_v1.o    : src/uuidlib_v1.c    src/uuid.h
so/uuidlib_v2.o    : src/uuidlib_v2.c    src/uuid.h
so/uuidlib_v3.o    : src/uuidlib_v3.c    src/uuid.h
so/uuidlib_v4.o    : src/uuidlib_v4.c    src/uuid.h
so/uuidlib_v5.o    : src/uuidlib_v5.c    src/uuid.h

# ===================================================

install: lib obj lib/libspcuuid.a
	install -d $(INCLUDE)/org/coman
	install src/uuid.h $(INCLUDE)/org/conman
	install lib/libspcuuid.a $(LIB)

remove:
	$(RM) -rf $(INCLUDE)/org/conman/uuid.h
	$(RM) -rf $(LIB)/libspcuuid.a
	
install-lua: lua
	install -d $(LUALIB)/org/conman
	install lib/lua-uuid.so $(LUALIB)/org/conman/uuid.so

remove-lua:
	$(RM) -rf $(LUALIB)/org/conman/uuid.so
	
clean:
	$(RM) -rf *~ src/*~ lib/ obj/ so/
