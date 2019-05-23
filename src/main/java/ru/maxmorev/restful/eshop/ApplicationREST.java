package ru.maxmorev.restful.eshop;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;

@SpringBootApplication
public class ApplicationREST extends SpringBootServletInitializer {

    public static void main(String[] args) {
        SpringApplication.run(ApplicationREST.class, args);
    }

}
