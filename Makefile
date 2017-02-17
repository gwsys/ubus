CFLAGS    = -fPIC -Wall  
LIBLDFLAGS  = -shared
LIBS = -lubox
TARGET  = libubus.so ubusd cli
LIBOBJS = libubus.o libubus-io.o libubus-obj.o libubus-sub.o libubus-req.o 
UBUSDOBJS =  ubusd.o ubusd_id.o ubusd_obj.o ubusd_proto.o ubusd_event.o
CLIOBJS = cli.o
dirs = lua
LUA_VER = 5.1

all: $(TARGET) subdirs

subdirs: libubus.so 
	$(foreach N,$(dirs),make -C $(N);)


libubus.so: $(LIBOBJS)
	$(CC) $(LIBLDFLAGS)  -o libubus.so $(LIBOBJS) $(LIBS)

ubusd: $(UBUSDOBJS) libubus.so
	$(CC)  -L./ -o ubusd $(UBUSDOBJS) $(LIBS) -lubus

cli: $(CLIOBJS) libubus.so 
	$(CC)  -L./ -o cli $(CLIOBJS) $(LIBS) -lblobmsg_json -lubus
	
clean: 
	rm -rf *.o $(TARGET)
	$(foreach N,$(dirs),make -C $(N) clean ;)

install-staging:
	cp libubus.so $(DESTDIR)/usr/lib
	cp ubusmsg.h ubus_common.h libubus.h $(DESTDIR)/usr/include

uninstall-staging:
	rm -f $(DESTDIR)/usr/lib/libubus.so
	rm -rf $(DESTDIR)/usr/include/ubusmsg.h
	rm -rf $(DESTDIR)/usr/include/ubus_common.h
	rm -rf $(DESTDIR)/usr/include/libubus.h

install:
	cp libubus.so $(DESTDIR)/usr/lib
	cp lua/ubus.so $(DESTDIR)/usr/lib/lua/$(LUA_VER)
	cp ubusd $(DESTDIR)/usr/sbin
	cp cli $(DESTDIR)/usr/bin

uninstall:
	rm -f $(DESTDIR)/usr/lib/libubus.so
	rm -f $(DESTDIR)/usr/lib/lua/$(LUA_VER)/ubus.so
	rm -f $(DESTDIR)/usr/sbin/ubusd
	rm -f $(DESTDIR)/usr/bin/cli


