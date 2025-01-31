package com.example.grpc;

import io.grpc.ManagedChannel;
import io.grpc.ManagedChannelBuilder;

public class GrpcClient {
    public static void main(String[] args) {
        ManagedChannel channel = ManagedChannelBuilder.forAddress("localhost", 5000)
                .usePlaintext()
                .build();
        
        GreeterGrpc.GreeterBlockingStub stub = GreeterGrpc.newBlockingStub(channel);
        
        for (int i = 0; i < 5; i++) {
            HelloRequest request = HelloRequest.newBuilder()
                    .setName("User " + i)
                    .build();
            HelloResponse response = stub.sayHello(request);
            System.out.println(response.getMessage());
        }
        
        channel.shutdown();
    }
}
