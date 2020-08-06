local protocol_pb = require 'protocol_pb'
local proxy_pb = require 'proxy_pb'

require 'panelLogin'


print('================decode================')
local head = protocol_pb.Header()
head.status = 2
print(head)
local body = proxy_pb.PAuthenticate()
body.code = '1'
body.sessionId = 'lskdjflsdfjk'
print(body)
local msg = Message.New()
msg.type = 0
msg.header = head:SerializeToString()
msg.body = body:SerializeToString()
print(msg.header)
print(msg.body)
print('================decode================')
local h = protocol_pb.Header()
local b = proxy_pb.PAuthenticate()
h:ParseFromString(msg.header)
b:ParseFromString(msg.body)

print('head.status='..head.status)
print('body.code='..body.code)
print('body.sessionId='..body.sessionId)


panelLogin.Start();


