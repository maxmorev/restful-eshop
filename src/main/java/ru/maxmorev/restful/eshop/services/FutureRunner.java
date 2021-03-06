package ru.maxmorev.restful.eshop.services;

import org.springframework.stereotype.Component;

import java.util.concurrent.CompletableFuture;
import java.util.concurrent.Executors;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.function.Supplier;

@Component
public class FutureRunner {

    private final ThreadPoolExecutor threadPoolExecutor = (ThreadPoolExecutor) Executors.newCachedThreadPool();

    public <T>CompletableFuture<T> runAction(Supplier<T> action){
        return CompletableFuture.supplyAsync(action, threadPoolExecutor );
    }

}
