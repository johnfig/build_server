require 'socket'
require 'pry'

def server
  socket = create_server_socket
  loop_and_listen_for_client_requests(socket)
end

def create_server_socket
  socket = Socket.new(:INET, :STREAM, 0) # create socket
  sockaddr = Addrinfo.tcp("127.0.0.1", 2222)
  socket.bind(sockaddr)
  socket.listen(5)
  socket
end

def loop_and_listen_for_client_requests(server)
  puts 'The Server is running on port 2222...'
  loop do
    client_socket, client_address_info = server.accept

    fork do
      handle_request(client_socket)
    end

    client_socket.close
  end
end

def handle_request(client_socket)
  request = client_socket.recv(1056)
  response = run_application_code
  client_socket.print response
end

def run_application_code
  app_response = "<html><body><h1>Hello World</h1><h2>This is the future!</h2></body></html\n"
  server_response = "HTTP/1.1 200 OK\r\n" +
                    "Content-Type: text/html\r\n" +
                    "Content-Length: #{app_response.bytesize}\r\n" +
                    "Connection: close\r\n" +
                    "\r\n" +
                    app_response
end

server