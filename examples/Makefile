CFLAGS    =  -Wall  -I../
LIBS = -lubox -lubus


all: server client 

server: server.o
	$(CC) -o server server.o $(LIBS)
	
client: client.o
	$(CC) -o client client.o $(LIBS)

clean:
	rm -rf *.o server client
