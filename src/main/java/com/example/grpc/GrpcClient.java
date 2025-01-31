package com.example.grpc;

import io.grpc.BindableService;
import io.grpc.ManagedChannel;
import io.grpc.ManagedChannelBuilder;
import io.grpc.ServerServiceDefinition;

public class GrpcClient {
    public static void main(String[] args) {
        int numRequests = args.length > 0 ? Integer.parseInt(args[0]) : 15;
        ManagedChannel channel = ManagedChannelBuilder.forAddress("localhost", 5000)
                .usePlaintext()
                .build();
        try {
            GreeterGrpc.GreeterBlockingStub stub = GreeterGrpc.newBlockingStub(channel);
            for (int i = 0; i < numRequests; i++) {
                String userName = "User " + i;
                HelloRequest request = HelloRequest.newBuilder()
                        .setName(userName)
                        .build();

                HelloResponse response = stub.sayHello(request);
                System.out.println("Response: " + response.getMessage());
            }


        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Client failed to connect or execute requests.");
        } finally {
            channel.shutdown();
        }

    }
}
