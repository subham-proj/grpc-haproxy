package com.example.grpc;

import io.grpc.stub.StreamObserver;
public class GreeterServiceImpl extends GreeterGrpc.GreeterImplBase {
    @Override
    public void sayHello(HelloRequest req, StreamObserver<HelloResponse> responseObserver) {
        String serverId = "Server-" + System.getProperty("server.id", "1");
        HelloResponse response = HelloResponse.newBuilder()
                .setMessage("Hello " + req.getName() + " from " + serverId)
                .build();
        responseObserver.onNext(response);
        responseObserver.onCompleted();
    }
}
